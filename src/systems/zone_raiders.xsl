<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:bs="http://www.battlescribe.net/schema/rosterSchema" 
                xmlns:exslt="http://exslt.org/common" 
                extension-element-prefixes="exslt">
    <xsl:output method="html" indent="yes"/> 

	<xsl:template match="bs:roster/bs:forces/bs:force">
		<html>
		<head>
		
			<style>
					<!-- inject:../build/style.css -->
					@import url("https://fonts.googleapis.com/css?family=Open+Sans&amp;display=swap");
 body {
     font-family: 'Open Sans', sans-serif;
}
 .card {
     width: 17.6cm;
     min-height: 4.81cm;
     border-radius: 0.4em;
     padding: 0px;
     border: 0.02cm solid black;
     margin-bottom: 0.5cm;
	 overflow: hidden;
}
 table {
     width: 100%;
     font-size: 10px;
     border-collapse: collapse;
     background-color: white;
}
 table tr {
     height: 0.45cm;
     border-bottom: 0.02cm solid #81B8C1;
}
 table td, table th {
     padding-left: 0.2cm;
     padding-right: 0.2cm;
     border-right: 0.02cm solid #81B8C1;
     text-align: center;
}
 table td:first-child, table th:first-child {
     text-align: left;
}
 table td:last-child, table th:last-child {
     border-right: 0px solid;
}
 table.stats {
     #border-top: 0.02cm solid black;
     #border-left: 0.02cm solid black;
     #border-right: 0.02cm solid black;
}
 table.stats tr {
     height: 0.65cm;
}
 table.stats tr:first-child {
     background-color: #D5E7EA;
}
 table.armor {
     #border-left: 0.02cm solid black;
     #border-right: 0.02cm solid black;
}
 table.armor tr:first-child {
     background-color: #D5E7EA;
}
 table.armor tr:last-child {
     border-bottom: 0px solid;
}
 table.weapon {
     border-top: 0.02cm solid black;
     #border-left: 0.02cm solid black;
     #border-right: 0.02cm solid black;
}
 table.weapon th:first-child , table.weapon td:first-child{
     width: 4.76cm;
}
 table.weapon tr:last-child {
     border-bottom: 0px solid;
}
 table.equipment {
     border-top: 0.02px solid black;
}
 table.equipment tr {
     height: 0.4cm;
     border-bottom: 0px solid;
     background-color: #D5E7EA;
}
 table.equipment td , table.equipment th{
     text-align: left;
     width: 50%;
}
 td.stat-field {
     width: 1.4cm;
}
 table.team {
     #border-top: 0.02cm solid black;
     #border-left: 0.02cm solid black;
     #border-right: 0.02cm solid black;
}
 table.team tr {
     height: 0.65cm;
}
 table.team tr:first-child {
     background-color: #D5E7EA;
}
 table.team tr:first-child th {
     text-align: center;
}
 table.rules, table.skill {
     border-top: 0.02cm solid black;
     #border-left: 0.02cm solid black;
     #border-right: 0.02cm solid black;
}
 table.rules tr, table.skill tr {
     height: 0.65cm;
}
 table.rules tr:first-child, table.skill tr:first-child{
     background-color: #D5E7EA;
}


table.rules tr:last-child, table.skill tr:last-child, table.team tr:last-child{
     border-bottom: 0px solid black;
}

 table.rules td , table.rules th,  table.skill td , table.skill th{
     text-align: left;
}

 table.rules tr:first-child th{
     text-align: center;
}

 table.rules th:first-child , table.rules td:first-child,  table.skill th:first-child , table.skill td:first-child{
     white-space: nowrap;
}


 @media print {
     .card {
         float: left;
         page-break-inside: avoid;
    }
	.page {
		float: left;
		page-break-after: always;
	}
}


					<!-- endinject -->
			</style>
		</head>
		<body>
		<section id="team">
				<div class="card page">
					<table  class="team">
						<tr>
							<th><xsl:value-of select='format-number(../../bs:costs/bs:cost/@value, "0")'/> RU</th>
							<th><xsl:value-of select="@catalogueName"/></th>
						</tr>
						<xsl:apply-templates select="bs:rules/bs:rule" mode="team"/>
					</table>
					
					
					
					<table  class="skill">
						<tr>
							<th>Skill</th>
							<th>Type</th>
							<th>Effect</th>
							<th>Requirements</th>
						</tr>
						<xsl:apply-templates select="bs:selections/bs:selection/bs:profiles/bs:profile[@typeName='Skill'][not(.=preceding::*)]" mode="skills"/>
					</table>	


					<table  class="skill">
						<tr>
							<th>Rule</th>
							<th>Effect</th>
						</tr>
						<xsl:apply-templates select="bs:selections/bs:selection/bs:selections/bs:selection/bs:selections/bs:selection/bs:rules/bs:rule[not(.=preceding::*)]" mode="rules"/>
					</table>


					<table  class="skill">
						<tr>
							<th>Equipment</th>
							<th>Effect</th>
						</tr>
						<xsl:apply-templates select="bs:selections/bs:selection/bs:selections/bs:selection/bs:selections/bs:selection/bs:profiles[not(.=preceding::*)]/bs:profile[@typeName='Equipment']" mode="equipment"/>
					</table>


					
				</div>	
			</section>
			
			<section id="cards">
				<xsl:apply-templates select="bs:selections/bs:selection[@type='model']" mode="card"/>
			</section>
			
		</body>
		</html>
	</xsl:template>
	
	

    <!-- inject:card.xsl -->
    	<!-- Renders the unit cards -->
	<xsl:template match="bs:selection[@type='model']" mode="card">
		<xsl:variable name="nodePoints">
	        <xsl:for-each select="bs:selections/bs:selection/bs:selections/bs:selection">
				<ItemCost>
					<xsl:value-of select="bs:costs/bs:cost[@name=' RU']/@value"/>
				</ItemCost>	               
	        </xsl:for-each>
	    </xsl:variable>
	    <xsl:variable name="subTotal" select="exslt:node-set($nodePoints)"/>			

		<div class="card">
		    <table  class="stats">
				<tr>
					<th>Raider Name</th>
					<th>Class</th>
					<th>Cost</th>
					<th>Speed</th>
					<th>Shooting</th>
					<th>Melee</th>
					<th>Defense</th>
					<th>Survival</th>
					<th>Aptitude</th>
				</tr>
				<tr>
					<td>&#160;</td>
					<td><xsl:value-of select="@name"/></td>
					<td><xsl:value-of select="sum($subTotal/ItemCost) + bs:costs/bs:cost/@value"/> </td>
					<td class="stat-field">
					<xsl:value-of select="bs:profiles/bs:profile[@typeName='Model']/bs:characteristics/bs:characteristic[@name='Speed']" />
					   <xsl:if test="contains(bs:selections/bs:selection/bs:selections/bs:selection/bs:profiles/bs:profile[@typeName='Armor'][1]/bs:characteristics/bs:characteristic[@name='Special'], '+1 Speed')">
							(<xsl:value-of select="bs:profiles/bs:profile[@typeName='Model']/bs:characteristics/bs:characteristic[@name='Speed']+1" />)
					   </xsl:if>
					
					</td>
					<td  class="stat-field"><xsl:value-of select="bs:profiles/bs:profile[@typeName='Model']/bs:characteristics/bs:characteristic[@name='Shooting']" /></td>
					<td  class="stat-field"><xsl:value-of select="bs:profiles/bs:profile[@typeName='Model']/bs:characteristics/bs:characteristic[@name='Melee']" /></td>
					<td  class="stat-field"><xsl:value-of select="bs:profiles/bs:profile[@typeName='Model']/bs:characteristics/bs:characteristic[@name='Defense']" /> (<xsl:value-of select="bs:profiles/bs:profile[@typeName='Model']/bs:characteristics/bs:characteristic[@name='Defense'] + bs:selections/bs:selection/bs:selections/bs:selection/bs:profiles/bs:profile[@typeName='Armor'][1]/bs:characteristics/bs:characteristic[@name='Defense Bonus']"/>)</td>
					<td  class="stat-field"><xsl:value-of select="bs:profiles/bs:profile[@typeName='Model']/bs:characteristics/bs:characteristic[@name='Survival']" /> (<xsl:value-of select="bs:profiles/bs:profile[@typeName='Model']/bs:characteristics/bs:characteristic[@name='Survival'] + bs:selections/bs:selection/bs:selections/bs:selection/bs:profiles/bs:profile[@typeName='Armor'][1]/bs:characteristics/bs:characteristic[@name='Survival Bonus']"/>)</td>
					<td  class="stat-field"><xsl:value-of select="bs:profiles/bs:profile[@typeName='Model']/bs:characteristics/bs:characteristic[@name='Aptitude']" /></td>
				</tr>
			</table>
			<table class="armor">
				<tr>
					<th>Armor</th>
					<th>Mobility Actions</th>
					<th>Defense Mod</th>
					<th>Survival Mod</th>
					<th>Special</th>
					<th>Level</th>
					<th>XP</th>
				</tr>
				<tr class="armor">
					<td><xsl:value-of select="bs:selections/bs:selection/bs:selections/bs:selection/bs:profiles/bs:profile[@typeName='Armor'][1]/@name"/></td>
					<td><xsl:value-of select="bs:selections/bs:selection/bs:selections/bs:selection/bs:profiles/bs:profile[@typeName='Armor'][1]/bs:characteristics/bs:characteristic[@name='Mobility Actions']"/></td>
					<td class="stat-field"><xsl:value-of select="bs:selections/bs:selection/bs:selections/bs:selection/bs:profiles/bs:profile[@typeName='Armor'][1]/bs:characteristics/bs:characteristic[@name='Defense Bonus']"/></td>
					<td class="stat-field"><xsl:value-of select="bs:selections/bs:selection/bs:selections/bs:selection/bs:profiles/bs:profile[@typeName='Armor'][1]/bs:characteristics/bs:characteristic[@name='Survival Bonus']"/></td>
					<td><xsl:value-of select="bs:selections/bs:selection/bs:selections/bs:selection/bs:profiles/bs:profile[@typeName='Armor'][1]/bs:characteristics/bs:characteristic[@name='Special']"/></td>
					<td><xsl:value-of select="bs:selections/bs:selection[@name='Starting Levels']/@number"/></td>
					<td>
						<xsl:choose>
									<xsl:when test="bs:selections/bs:selection[@name='Xp']/@number">
										<xsl:value-of select="bs:selections/bs:selection[@name='Xp']/@number"/>
									</xsl:when>
									<xsl:otherwise>
										0 
									</xsl:otherwise>	
							</xsl:choose>	
					</td>
				</tr>
			</table>
			
			<xsl:variable name="weapons" select="bs:selections/bs:selection/bs:selections/bs:selection/bs:profiles/bs:profile[@typeName='Weapon']"/>
				
			<table  class="weapon">	
				<tr>
					<th>Weapons</th>
					<th>Range</th>
					<th>Strength</th>
					<th>Ammo</th>
					<th>Special</th>
				</tr>
				<tr>
					<td><xsl:value-of select="$weapons[1]/@name"/></td>
					<td  class="stat-field">
						<xsl:if test="$weapons[1]">
							<xsl:value-of select="$weapons[1]/bs:characteristics/bs:characteristic[@name='Range']"/>		
						</xsl:if>
					</td>
					<td class="stat-field">
						<xsl:if test="$weapons[1]">
							<xsl:value-of select="$weapons[1]/bs:characteristics/bs:characteristic[@name='Strenght' or @name='Strength']"/>		
						</xsl:if>
					</td>
					<td class="stat-field">
						<xsl:if test="$weapons[1]">
							<xsl:value-of select="$weapons[1]/bs:characteristics/bs:characteristic[@name='Ammo']"/>							
						</xsl:if>
					</td>
					<td>
						<xsl:if test="$weapons[1]">
							<xsl:value-of select="$weapons[1]/bs:characteristics/bs:characteristic[@name='Special']"/>		
						</xsl:if>
					</td>
				</tr>
				<tr>
					<td><xsl:value-of select="$weapons[2]/@name"/></td>
					<td>
						<xsl:if test="$weapons[2]">
							<xsl:value-of select="$weapons[2]/bs:characteristics/bs:characteristic[@name='Range']"/>		
						</xsl:if>
					</td>
					<td>
						<xsl:if test="$weapons[2]">
							<xsl:value-of select="$weapons[2]/bs:characteristics/bs:characteristic[@name='Strenght' or @name='Strength']"/>		
						</xsl:if>
					</td>
					<td>
						<xsl:if test="$weapons[2]">
							<xsl:value-of select="$weapons[2]/bs:characteristics/bs:characteristic[@name='Ammo']"/>
						</xsl:if>
					</td>
					<td>
						<xsl:if test="$weapons[2]">
							<xsl:value-of select="$weapons[2]/bs:characteristics/bs:characteristic[@name='Special']"/>		
						</xsl:if>
					</td>
				
				</tr>
				<tr>
					<td><xsl:value-of select="$weapons[3]/@name"/></td>
					<td>
						<xsl:if test="$weapons[3]">
							<xsl:value-of select="$weapons[3]/bs:characteristics/bs:characteristic[@name='Range']"/>		
						</xsl:if>
					</td>
					<td>
						<xsl:if test="$weapons[3]">
							<xsl:value-of select="$weapons[3]/bs:characteristics/bs:characteristic[@name='Strenght' or @name='Strength']"/>		
						</xsl:if>
					</td>
					<td>
						<xsl:if test="$weapons[3]">						
							<xsl:value-of select="$weapons[3]/bs:characteristics/bs:characteristic[@name='Ammo']"/>									
						</xsl:if>
					</td>
					<td>
						<xsl:if test="$weapons[3]">
							<xsl:value-of select="$weapons[3]/bs:characteristics/bs:characteristic[@name='Special']"/>		
						</xsl:if>
					</td>
				</tr>
			</table>
			<table  class="equipment">	
				<tr>
					<th>Equipment</th>
					<th>Skills</th>
				</tr>	
				<tr>
					<td>
					<xsl:for-each select="bs:selections/bs:selection/bs:selections/bs:selection/bs:profiles/bs:profile[@typeName='Equipment']">
							<div class="gear-name">
								<xsl:value-of select="@name"/>
							</div>                
					</xsl:for-each>	
					</td>
				
					<td>
					<xsl:for-each select="bs:profiles/bs:profile[@typeName='Skill']">
							<xsl:variable name="i" select="position()"/>
							<span class="skill-name">
									<xsl:if test="$i!=1">
									  ,
									</xsl:if> 
									<xsl:value-of select="@name"/>
							</span>
					</xsl:for-each>

					</td>
				</tr>	
			</table>
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

			



		</div>
	</xsl:template>
    <!-- endinject -->


	<xsl:template match="bs:characteristics/bs:characteristic" mode="stats-template">
		
		
        <div class="col-xs-2  align-middle stats">
            <xsl:value-of select="."/> 
			
			<!-- DEFFENSE -->
			<xsl:if test="position()=last()-5">   (+<xsl:value-of select="../../../../bs:selections/bs:selection/bs:selections/bs:selection/bs:profiles/bs:profile[@typeName='Armor'][1]/bs:characteristics/bs:characteristic[@name='Defense Bonus']"/>)
			</xsl:if>
			<!-- SURVIVAL -->
			<xsl:if test="position()=last()-3">   (+<xsl:value-of select="../../../../bs:selections/bs:selection/bs:selections/bs:selection/bs:profiles/bs:profile[@typeName='Armor'][1]/bs:characteristics/bs:characteristic[@name='Survival Bonus']"/>)
			</xsl:if>
			
		</div>
    </xsl:template>
	



	<xsl:template match="bs:rule" mode="team">
				<tr>
					<td><xsl:value-of select="@name"/></td>
					<td><xsl:value-of select="."/></td>
				</tr>
    </xsl:template>


	
	
	<xsl:template match="bs:characteristics" mode="skills">
				<tr>
					<td><xsl:value-of select="../@name"/></td>
					<td><xsl:value-of select="bs:characteristic[@name='Type']"/></td>
					<td><xsl:value-of select="bs:characteristic[@name='Effect']"/></td>
					<td><xsl:value-of select="bs:characteristic[@name='Requirements']"/></td>
				</tr>
    </xsl:template>



	
	<xsl:template match="bs:rule" mode="rules">
			<tr>
				<td><xsl:value-of select="@name"/></td>
				<td><xsl:value-of select="bs:description"/></td>
			</tr>
    </xsl:template>
	
	<xsl:template match="bs:profile" mode="equipment">
			<tr>
				<td><xsl:value-of select="@name"/></td>
				<td><xsl:value-of select="bs:characteristics/bs:characteristic[@name='Description']"/></td>
			</tr>
    </xsl:template>

</xsl:stylesheet>