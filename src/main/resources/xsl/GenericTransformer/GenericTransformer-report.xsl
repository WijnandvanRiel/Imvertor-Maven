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
    xmlns:ext="http://www.imvertor.org/xsl/extensions"
    xmlns:imvert="http://www.imvertor.org/schema/system"
    xmlns:imf="http://www.imvertor.org/xsl/functions"
    
    exclude-result-prefixes="#all"
    version="2.0">
    
    <!-- 
     Reporting stylesheet for the Tester step.
    -->
    <xsl:import href="../common/Imvert-common.xsl"/>
    
    <?x <xsl:output encoding="UTF-8" method="xml" indent="yes"/> x?>
    
    <!-- 
        context document is the parms.xml file. 
    -->
    <xsl:template match="/config">
        <report>
            <step-display-name>Tester</step-display-name>
            <summary>
                <info label="my label">My value</info>
            </summary>
            <page>
                <title>Title of the first Tester reporting page</title>
                <intro>
                    <p>Introduction here</p>
                </intro>
                <content>
                    <div>
                        <h1>First report page</h1>
                        <p>This is the report on the step Tester, the first "division" </p>
                        <xsl:call-template name="show-some-info"/>
                    </div>
                    <div>
                        <h1>Second report page</h1>
                        <p>This is the report on the step Tester, the second "division" </p>
                        <xsl:call-template name="show-some-info"/>
                    </div>
                </content>
            </page>
            <page>
                <title>Title of the second Tester reporting page</title>
                <intro>
                    <p>Introduction here</p>
                </intro>
                <content>
                    <div>
                        <h1>First report page</h1>
                        <p>This is the report on the step Tester, the first "division" </p>
                        <xsl:call-template name="show-some-info"/>
                    </div>
                    <div>
                        <h1>Second report page</h1>
                        <p>This is the report on the step Tester, the second "division" </p>
                        <xsl:call-template name="show-some-info"/>
                    </div>
                </content>
            </page>
        </report>
    </xsl:template>

    <xsl:template name="show-some-info">
        <table>
            <xsl:for-each select="/config/messages/message">
                <tr>
                    <td><xsl:value-of select="type"/></td>
                    <td><xsl:value-of select="text"/></td>
                </tr>
            </xsl:for-each>
        </table>
    </xsl:template>
</xsl:stylesheet>
