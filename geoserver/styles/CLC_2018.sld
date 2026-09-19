<?xml version="1.0" encoding="UTF-8"?>
<sld:StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:sld="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc" xmlns:gml="http://www.opengis.net/gml" version="1.0.0">
  <sld:NamedLayer>
    <sld:Name>CLC_2018 — clc_2018_pereira</sld:Name>
    <sld:UserStyle>
      <sld:Name>CLC_2018 — clc_2018_pereira</sld:Name>
      <sld:FeatureTypeStyle>
        <sld:Rule>
          <sld:Name>1.1.1. Tejido urbano continuo</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>111*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#cc0000</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>1.1.2. Tejido urbano discontinuo</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>112*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#f80000</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>1.2.1. Zonas industriales o comerciales</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>121*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#cc4d2a</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>1.2.2. Red vial, ferroviaria y terrenos asociados</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>122*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#d96545</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>1.2.3. Zonas portuarias</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>123*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#e1846b</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>1.2.4. Aeropuertos</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>124*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#e79c87</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>1.2.5. Obras hidráulicas</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>125*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#eeb9aa</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>1.3.1. Zonas de extracción minera</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>131*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#a600cc</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>1.3.2. Zona de disposición de residuos</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>132*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#d317ff</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>1.4.1. Zonas verdes urbanas</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>141*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#ff8080</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>1.4.2. Instalaciones recreativas</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>142*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#ffafaf</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>2.1.1. Otros cultivos transitorios</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>211*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#ffffa6</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>2.1.2. Cereales</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>212*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#eee800</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>2.1.3. Oleaginosas y leguminosas</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>213*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#ffff5f</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>2.1.4. Hortalizas</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>214*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#e1d200</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>2.1.5. Tubérculos</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>215*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#d2cd00</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>2.2.1. Cultivos permanentes herbáceos</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>221*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#f2cca6</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>2.2.2. Cultivos permanentes arbustivos</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>222*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#f2a64d</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>2.2.3. Cultivos permanentes arbóreos</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>223*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#e6a600</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>2.2.4. Cultivos agroforestales</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>224*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#cc900a</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>2.2.5. Cultivos confinados</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>225*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#824a12</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>2.3.1. Pastos limpios</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>231*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#ccffcc</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>2.3.2. Pastos arbolados</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>232*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#9eff9e</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>2.3.3. Pastos enmalezados</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>233*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#9effc8</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>2.4.1. Mosaico de cultivos</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>241*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#ffe6a6</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>2.4.2. Mosaico de pastos y cultivos</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>242*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#ffd875</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>2.4.3. Mosaico de cultivos, pastos y espacios naturales</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>243*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#ffc941</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>2.4.4. Mosaico de pastos con espacios naturales</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>244*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#feb500</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>2.4.5. Mosaico de cultivos con espacios naturales</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>245*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#ffb03c</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>3.1.1. Bosque denso</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>311*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#478f00</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>3.1.2. Bosque abierto</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>312*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#55ab00</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>3.1.3. Bosque fragmentado</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>313*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#61c200</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>3.1.4. Bosque de galería y ripario</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>314*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#70e000</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>3.1.5. Plantación forestal</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>315*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#80ff00</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>3.2.1. Herbazal</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>321*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#ccf24e</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>3.2.2. Arbustal</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>322*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#acdb0f</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>3.2.3. Vegetación secundaria o en transición</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>323*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#96bf0d</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>3.3.1. Zonas arenosas naturales</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>331*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#c2c2c2</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>3.3.2. Afloramientos rocosos</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>332*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#b3b3b3</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>3.3.3. Tierras desnudas y degradadas</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>333*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#9e9e9e</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>3.3.4. Zonas quemadas</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>334*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#898989</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>3.3.5. Zonas glaciares y nivales</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>335*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#6565b4</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>4.1.1. Zonas pantanosas</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>411*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#a6a6ff</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>4.1.2. Turberas</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>412*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#4d91ff</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>4.1.3. Vegetación acuática sobre cuerpos de agua</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>413*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#5050ff</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>4.2.1. Pantanos costeros</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>421*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#ccccff</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>4.2.2. Salitral</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>422*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#b7b7ff</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>4.2.3. Sedimentos expuestos en bajamar</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>423*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#a6a6e6</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>5.1.1. Ríos</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>511*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#0000f8</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>5.1.2. Lagunas, lagos y ciénagas naturales</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>512*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#0080ff</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>5.1.3. Canales</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>513*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#00b2ff</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>5.1.4. Cuerpos de agua artificiales</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>514*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#00cef2</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>5.2.1. Lagunas costeras</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>521*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#45e0f5</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>5.2.3. Estanques para acuicultura marina</sld:Name>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsLike wildCard="*" singleChar="." escapeChar="!">
              <ogc:PropertyName>codigo</ogc:PropertyName>
              <ogc:Literal>523*</ogc:Literal>
            </ogc:PropertyIsLike>
          </ogc:Filter>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#ccf6ff</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>&lt;all other values&gt;</sld:Name>
          <sld:ElseFilter xmlns:se="http://www.opengis.net/se"/>
          <sld:PolygonSymbolizer>
            <sld:Fill>
              <sld:CssParameter name="fill">#cabff2</sld:CssParameter>
            </sld:Fill>
          </sld:PolygonSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </sld:NamedLayer>
</sld:StyledLayerDescriptor>

