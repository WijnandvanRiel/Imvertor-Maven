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
 
 This stylesheet enriches the to XML transformed version of the base-configuration.xls file.
-->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:UML="omg.org/UML1.3"
    
    xmlns:imvert="http://www.imvertor.org/schema/system"
    xmlns:imf="http://www.imvertor.org/xsl/functions"
    xmlns:imvert-result="http://www.imvertor.org/schema/imvertor/application/v20160201"

    xmlns:bg="http://www.egem.nl/StUF/sector/bg/0310" 
    xmlns:metadata="http://www.kinggemeenten.nl/metadataVoorVerwerking" 
    xmlns:ztc="http://www.kinggemeenten.nl/ztc0310" 
    xmlns:stuf="http://www.stufstandaarden.nl/onderlaag/stuf0302" 

    xmlns:ss="http://schemas.openxmlformats.org/spreadsheetml/2006/main"
    
    version="2.0">
    
    <xsl:import href="extension/Imvert-common-zipserializer.xsl"/>
    <xsl:import href="extension/Imvert-common-excelserializer.xsl"/>
   
    <xsl:output indent="yes" method="xml" encoding="UTF-8"/>
    
    <!-- for all Excel handling -->

    <xsl:variable name="workfolder-path" select="imf:get-config-string('properties','work-serialize-folder')"/>
    
    <!-- for Excel OOXML -->
    
    <xsl:variable name="serialized-folder" select="imf:serializeFromZip($endproduct-base-config-excel,$workfolder-path)"/>
    <xsl:variable name="content-url" select="imf:file-to-url(concat($serialized-folder,'/__content.xml'))"/>
    <xsl:variable name="content-doc" select="imf:document($content-url)"/>
    <xsl:variable name="shared-strings" select="$content-doc/files/file/ss:sst/ss:si"/>
    
    <!-- for excel 97 -->
    <!-- The last variable in this block contains the raw XML version of the base-configuration.xls file. --> 
    <xsl:variable name="endproduct-base-config-excel" select="imf:get-config-string('system','endproduct-base-config-file')"/>
    <xsl:variable name="endproduct-base-config-excel-url" select="imf:serializeExcel($endproduct-base-config-excel,concat($workfolder-path,'/excel.xml'))"/>
    <xsl:variable name="endproduct-base-config-excel-doc" select="imf:document($endproduct-base-config-excel-url)"/> 
    
    <!-- Kolomnamen -->
    <!-- Sheet 'XML attributes' -->
    <xsl:variable name="id" select="workbook/sheet[name='XML attributes']/row[@number = 1]/col[@number = 0]/data"/>
    

   <!-- Templates for processing and enriching the product configuration file. 
        Most of them just recreate the related element. -->    
   <xsl:template match="workbook">
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
    </xsl:template>

    <xsl:template match="sheet">
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
    </xsl:template>
    
    <xsl:template match="name">
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
    </xsl:template>

   <!-- The following template only recreates rows 4 and larger (first row has @number = 0) in which  the first column isn't empty. -->
   <xsl:template match="row">
		<xsl:if test="@number &gt; 2 and col[@number=0]/data!=''">
			<xsl:copy>
				<xsl:apply-templates select="*|@*"/>
			</xsl:copy>
		</xsl:if>
    </xsl:template>
    
    <!-- This template processes each column of the base-configuration.xls file and provides it with the xml-attributes 'name' and 'type'. -->
    <xsl:template match="col">
       <xsl:variable name="name-type" select="'tv-name'"/>
       <xsl:variable name="sheetName" select="ancestor::sheet/name"/>
       <xsl:variable name="colNumber">
           <xsl:value-of select="@number"/>
       </xsl:variable>
       <xsl:copy>
          <xsl:choose>
              <!-- Within the context of the worksheet 'Berichtgerelateerde gegevens' the 'type' xml-attribute has the value 'Stuurgegevens' or 'Parameters' depending on the type of component. -->
              <xsl:when test="$sheetName = 'Berichtgerelateerde gegevens'">
                  <xsl:choose>
                      <xsl:when test="@number=0"><xsl:attribute name="name" select="'typeBericht'"/></xsl:when>
                      <xsl:when test="@number=1"><xsl:attribute name="name" select="'synchroon?'"/></xsl:when>
                      <xsl:when test="@number=2"/>
                      <xsl:when test="@number=3"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/><xsl:attribute name="type" select="'Stuurgegevens'"/></xsl:when>
                      <xsl:when test="@number=4"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/><xsl:attribute name="type" select="'Stuurgegevens'"/></xsl:when>
                      <xsl:when test="@number=5"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/><xsl:attribute name="type" select="'Stuurgegevens'"/></xsl:when>
                      <xsl:when test="@number=6"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/><xsl:attribute name="type" select="'Stuurgegevens'"/></xsl:when>
                      <xsl:when test="@number=7"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/><xsl:attribute name="type" select="'Stuurgegevens'"/></xsl:when>
                      <xsl:when test="@number=8"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/><xsl:attribute name="type" select="'Stuurgegevens'"/></xsl:when>
                      <xsl:when test="@number=9"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/><xsl:attribute name="type" select="'Stuurgegevens'"/></xsl:when>
                      <xsl:when test="@number=10"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/><xsl:attribute name="type" select="'Stuurgegevens'"/></xsl:when>
                      <xsl:when test="@number=11"/>
                      <xsl:when test="@number=12"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/><xsl:attribute name="type" select="'Parameters'"/></xsl:when>
                      <xsl:when test="@number=13"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/><xsl:attribute name="type" select="'Parameters'"/></xsl:when>
                      <xsl:when test="@number=14"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/><xsl:attribute name="type" select="'Parameters'"/></xsl:when>
                      <xsl:when test="@number=15"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/><xsl:attribute name="type" select="'Parameters'"/></xsl:when>
                      <xsl:when test="@number=16"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/><xsl:attribute name="type" select="'Parameters'"/></xsl:when>
                      <xsl:when test="@number=17"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/><xsl:attribute name="type" select="'Parameters'"/></xsl:when>
                      <xsl:when test="@number=18"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/><xsl:attribute name="type" select="'Parameters'"/></xsl:when>
                      <xsl:when test="@number=19"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/><xsl:attribute name="type" select="'Parameters'"/></xsl:when>
                      <xsl:when test="@number=20"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/><xsl:attribute name="type" select="'Parameters'"/></xsl:when>
                      <xsl:when test="@number=21"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/><xsl:attribute name="type" select="'Parameters'"/></xsl:when>
                      <xsl:when test="@number=22"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/><xsl:attribute name="type" select="'Parameters'"/></xsl:when>
                      <xsl:when test="@number=23"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/><xsl:attribute name="type" select="'Parameters'"/></xsl:when>
                      <xsl:when test="@number=24"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/><xsl:attribute name="type" select="'Parameters'"/></xsl:when>
                  </xsl:choose>               
              </xsl:when>
<!-- ROME: In de volgende when's moet de kolomnaam eigenlijk ook via de functie ímf:getColumnName gegenereerd worden. Alleen dan in een variant die de naam niet normaliseert. -->
              <xsl:when test="$sheetName = 'XML attributes'">
                  <xsl:choose>
                      <xsl:when test="@number=0"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/></xsl:when>
                      <xsl:when test="@number=1"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/></xsl:when>
                      <xsl:when test="@number=2"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/></xsl:when>
                      <xsl:when test="@number=3"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/></xsl:when>
                      <xsl:when test="@number=4"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/></xsl:when>
                      <xsl:when test="@number=5"/>
                      <xsl:when test="@number=6"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/></xsl:when>
                      <xsl:when test="@number=7"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/></xsl:when>
                      <xsl:when test="@number=8"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/></xsl:when>
                      <xsl:when test="@number=9"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/></xsl:when>
                      <xsl:when test="@number=10"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/></xsl:when>
                      <xsl:when test="@number=11"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/></xsl:when>
                      <xsl:when test="@number=12"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/></xsl:when>
                      <xsl:when test="@number=13"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/></xsl:when>
                      <xsl:when test="@number=14"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/></xsl:when>
                      <xsl:when test="@number=15"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/></xsl:when>
                      <xsl:when test="@number=16"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/></xsl:when>
                      <xsl:when test="@number=17"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/></xsl:when>
                      <xsl:when test="@number=18"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/></xsl:when>
                      <xsl:when test="@number=19"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/></xsl:when>
                      <xsl:when test="@number=20"><xsl:attribute name="name" select="imf:getColumnName($sheetName,$colNumber,$name-type)"/></xsl:when>
                  </xsl:choose>
              </xsl:when>
          </xsl:choose> 
          <xsl:apply-templates select="*|@*"/>
       </xsl:copy>         
    </xsl:template>
 
    <xsl:template match="data">
		<xsl:copy>
			<xsl:value-of select="."/>
		</xsl:copy>
    </xsl:template>
 
    <xsl:template match="format"/>

    <xsl:template match="font"/>

    <xsl:template match="*|@*">
		<xsl:copy/>
    </xsl:template>
  
    
    <!-- Only for OOXML: The workbook is the container; strings in cells may be listed in shared strings. so resolve all strings first --> 
    <xsl:template match="ss:*" mode="resolve-strings">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="resolve-strings"/>
        </xsl:copy>
    </xsl:template>
 
    <xsl:template match="ss:sheetData/ss:row/ss:c/ss:v" mode="resolve-strings">
        <xsl:copy>
            <xsl:value-of select="$shared-strings[position() = (xs:integer(current()) + 1)]"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- This function retrieves the normalized name of the column being processed. To be able to do this the related sheetname and columnnumber are neccessary to get the columnname as defined within the 
         Excel sheet. Subsequently the normalized name of the column is generated using the imf:get-normalized-name() function in the tv-name mode. -->
    <xsl:function name="imf:getColumnName" as="xs:string">
        <xsl:param name="sheetName"/>
        <xsl:param name="colNumber"/>
        <xsl:param name="name-type"/>
        <xsl:variable name="name-element" select="$endproduct-base-config-excel-doc//sheet[name=$sheetName]/row[@number=1]/col[@number=$colNumber]/data"/>
        <xsl:value-of select="$name-element"/>
    </xsl:function>
    
    <!-- Return the property element (imvert:attribute or imvert:association) for the package, class and property name passed.
         If the names are the original (UML) names, set is-original to true. -->  
    <xsl:function name="imf:get-property-by-name" as="element()?">
        <xsl:param name="package-name" as="xs:string"/>
        <xsl:param name="class-name" as="xs:string"/>
        <xsl:param name="property-name" as="xs:string"/>
        <xsl:param name="is-original" as="xs:boolean"/>
        
        <xsl:variable name="property" as="element()*">
            <!-- this property may have been defined on a supertype -->
            <xsl:variable name="class" select="imf:get-class-by-name($package-name,$class-name,$is-original)"/>
            <xsl:choose>
               <xsl:when test="exists($class)">
                   <xsl:for-each select="($class,imf:get-superclasses($class))">
                       <xsl:choose>
                           <xsl:when test="$is-original">
                               <xsl:sequence select="*/*[imvert:name/@original = $property-name]"/>
                           </xsl:when>
                           <xsl:otherwise>
                               <xsl:sequence select="*/*[imvert:name = $property-name]"/>
                           </xsl:otherwise>
                       </xsl:choose>
                   </xsl:for-each>
               </xsl:when>
               <xsl:otherwise>
                   <xsl:sequence select="imf:msg('ERROR','No such class: [1] in package: [2]', ($class-name,$package-name))"/>
               </xsl:otherwise>
           </xsl:choose>
        </xsl:variable>
        <!-- property may have been defined on several supertypes; choose "nearest" --> 
        <xsl:sequence select="$property[1]"/>
    </xsl:function>
    
</xsl:stylesheet>
