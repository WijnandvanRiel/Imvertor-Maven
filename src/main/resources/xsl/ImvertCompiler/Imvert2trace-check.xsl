<?xml version="1.0" encoding="UTF-8"?>
<!-- 
 * Copyright (C) 2016 Dienst voor het kadaster en de openbare registers
 * 
 * This file is part of Imvertor.
 *
 * Imvertor is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Imvertor is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Imvertor.  If not, see <http://www.gnu.org/licenses/>.
-->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    
    xmlns:imvert="http://www.imvertor.org/schema/system"
    xmlns:ext="http://www.imvertor.org/xsl/extensions"
    xmlns:imf="http://www.imvertor.org/xsl/functions"
    
    exclude-result-prefixes="#all"
    version="2.0">
    
    <!-- 
        Generate a file that lists package dependencies.
    -->
    
    <xsl:import href="../common/Imvert-common.xsl"/>
    <xsl:import href="../common/Imvert-common-validation.xsl"/>
    <xsl:import href="../common/Imvert-common-derivation.xsl"/>
    
    <!-- get all imvert:packages elements that represent a supplier for this package -->
    <xsl:variable name="suppliers" select="/imvert:packages/imvert:supplier"/>
    <xsl:variable name="supplier-packages" select="for $supplier in $suppliers return imf:get-trace-supplier-application(imf:get-trace-supplier-subpath($supplier))"/>
    <xsl:variable name="supplier-subpaths" select="string-join(for $s in ($supplier-packages) return imf:get-trace-supplier-subpath($s/imvert:project, $s/imvert:application, $s/imvert:release),', ')"/>
    
    <xsl:template match="/">
        <xsl:variable name="application-package" select="/imvert:packages/imvert:package[not(imvert:stereotype = ('EXTERN','SYSTEM')) and empty(imvert:ref-master)]"/>
        <root>
            <xsl:choose>
                <xsl:when test="exists($suppliers) and $validate-trace-full">
                    <xsl:apply-templates select="$application-package"/>
                    <xsl:value-of select="'Traced and checked'"/>
                </xsl:when>
                <xsl:when test="exists($suppliers)">
                    <xsl:value-of select="'Traced but not checked'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'Not traced and not checked'"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:for-each select="$supplier-packages">
                <xsl:variable name="subpath" select="imf:get-trace-supplier-subpath(imvert:project, imvert:application, imvert:release)"/>
                <xsl:variable name="errors" select="xs:integer((imvert:process/imvert:errors,0)[1])"/>
                <xsl:variable name="warnings" select="xs:integer((imvert:process/imvert:warnings,0)[1])"/>
                <xsl:variable name="phase" select="(imvert:phase,'0')[1]"/>
                
                <!-- TODO dit afhankelijk maken van de configuratie in input/version-rules -->
                <xsl:sequence select="imf:report-error(., 
                    $errors != 0,
                    'The supplier [1] has [2] errors. You cannot derive from that model.',($subpath,$errors))"/>
                <xsl:sequence select="imf:report-warning(., 
                    $warnings != 0,
                    'The supplier [1] has [2] warnings. Are you sure you want to derive from that model?',($subpath,$warnings))"/>
                <xsl:sequence select="imf:report-warning(., 
                    not($phase = ('2','3')),
                    'The supplier [1] is in phase [2]. Are you sure you want to derive from that model?',($subpath,imvert:phase/(@original|text())[1]))"/>
    
            </xsl:for-each>
        </root>
    </xsl:template>
        
    <xsl:template match="imvert:package">
        <xsl:variable name="this" select="."/>
        <xsl:variable name="is-derived" select="imf:boolean(imvert:derived)"/>
        <xsl:variable name="trace" select="(.//imvert:trace[not(@origin='system')])[1]"/>
        
        <!-- check if the package is derived; if not, no traces were expected (but this is not an error) --> 
        <xsl:sequence select="imf:report-warning($this, 
            not($is-derived) and exists($trace),
            'This package is not derived but traces were found, starting at [1]',$trace/..)"/>

        <xsl:apply-templates select="imvert:class"/>
    </xsl:template>
    
    <!-- check if the construct is in a derived package and if so, if it has a trace --> 
    <xsl:template match="imvert:class | imvert:attribute | imvert:association">
        <xsl:variable name="this" select="."/>
        <!-- when not derived, skip any traces -->
        <xsl:variable name="is-derived" select="imf:boolean((ancestor::*/imvert:derived)[1])"/>
        
        <xsl:variable name="is-derived-tv" select="(imf:get-tagged-value(.,'##CFG-TV-ISDERIVED'),'Zie package')[1]"/>
        <xsl:variable name="is-derived-by-tv" select="$is-derived-tv = 'Ja'"/>
        <xsl:variable name="look-at-package" select="$is-derived-tv = 'Zie package'"/>
        
        <xsl:variable name="must-be-derived" select="($is-derived and $look-at-package) or $is-derived-by-tv"/>
        <!--<xsl:message select="imf:insert-fragments-by-index('[1] [2] [3] [4]',($is-derived-tv,$is-derived-by-tv,$look-at-package,$must-be-derived))"/>-->
        
        <xsl:sequence select="imf:report-warning($this, 
            $validate-trace-full and 
            $must-be-derived and  
            (empty($this/imvert:trace) and empty($this/imvert:proxy)),
            'This construct should be derived (but is not)',())"/>
        
        <xsl:if test="$must-be-derived">
            <xsl:for-each select="($this/imvert:trace,$this/imvert:proxy)">
                <xsl:variable name="trace-id" select="."/>        
                <xsl:variable name="trace-construct" select="imf:get-trace-construct-by-id(..,$trace-id,$all-derived-models-doc)"/>        
                <xsl:variable name="type" select="local-name()"/>
                <xsl:sequence select="imf:report-warning($this, 
                    $validate-trace-full and empty($trace-construct),
                    'This construct is not [1]-derived from a known construct in (any of) the supplier(s) [2]',($type, $supplier-subpaths))"/>
            </xsl:for-each>
        </xsl:if>
        
        <xsl:apply-templates select="*/imvert:attribute"/>
        <xsl:apply-templates select="*/imvert:association"/>
        
    </xsl:template>
    
    <xsl:template match="node()">
        <!-- skip -->
    </xsl:template>
    
</xsl:stylesheet>
