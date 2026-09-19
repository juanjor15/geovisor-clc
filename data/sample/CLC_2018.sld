<?xml version='1.0' encoding='UTF-8'?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:se="http://www.opengis.net/se" xmlns:ogc="http://www.opengis.net/ogc" version="1.1.0" xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.1.0/StyledLayerDescriptor.xsd">
  <NamedLayer>
    <se:Name>CLC_2018 — clc_2018_pereira</se:Name>
    <UserStyle>
      <se:Name>CLC_2018 — clc_2018_pereira</se:Name>
      <se:FeatureTypeStyle>
        <se:Rule>
          <se:Name>1.1.1. Tejido urbano continuo</se:Name>
          <se:Description>
            <se:Title>1.1.1. Tejido urbano continuo</se:Title>
            <se:Abstract>1.1.1. Tejido urbano continuo</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>111</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#cc0000</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>1.1.2. Tejido urbano discontinuo</se:Name>
          <se:Description>
            <se:Title>1.1.2. Tejido urbano discontinuo</se:Title>
            <se:Abstract>1.1.2. Tejido urbano discontinuo</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>112</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#f80000</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>1.2.1. Zonas industriales o comerciales</se:Name>
          <se:Description>
            <se:Title>1.2.1. Zonas industriales o comerciales</se:Title>
            <se:Abstract>1.2.1. Zonas industriales o comerciales</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>121</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#cc4d2a</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>1.2.2. Red vial, ferroviaria y terrenos asociados</se:Name>
          <se:Description>
            <se:Title>1.2.2. Red vial, ferroviaria y terrenos asociados</se:Title>
            <se:Abstract>1.2.2. Red vial, ferroviaria y terrenos asociados</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>122</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#d96545</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>1.2.3. Zonas portuarias</se:Name>
          <se:Description>
            <se:Title>1.2.3. Zonas portuarias</se:Title>
            <se:Abstract>1.2.3. Zonas portuarias</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>123</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#e1846b</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>1.2.4. Aeropuertos</se:Name>
          <se:Description>
            <se:Title>1.2.4. Aeropuertos</se:Title>
            <se:Abstract>1.2.4. Aeropuertos</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>124</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#e79c87</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>1.2.5. Obras hidráulicas</se:Name>
          <se:Description>
            <se:Title>1.2.5. Obras hidráulicas</se:Title>
            <se:Abstract>1.2.5. Obras hidráulicas</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>125</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#eeb9aa</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>1.3.1. Zonas de extracción minera</se:Name>
          <se:Description>
            <se:Title>1.3.1. Zonas de extracción minera</se:Title>
            <se:Abstract>1.3.1. Zonas de extracción minera</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>131</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#a600cc</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>1.3.2. Zona de disposición de residuos</se:Name>
          <se:Description>
            <se:Title>1.3.2. Zona de disposición de residuos</se:Title>
            <se:Abstract>1.3.2. Zona de disposición de residuos</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>132</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#d317ff</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>1.4.1. Zonas verdes urbanas</se:Name>
          <se:Description>
            <se:Title>1.4.1. Zonas verdes urbanas</se:Title>
            <se:Abstract>1.4.1. Zonas verdes urbanas</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>141</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#ff8080</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>1.4.2. Instalaciones recreativas</se:Name>
          <se:Description>
            <se:Title>1.4.2. Instalaciones recreativas</se:Title>
            <se:Abstract>1.4.2. Instalaciones recreativas</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>142</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#ffafaf</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>2.1.1. Otros cultivos transitorios</se:Name>
          <se:Description>
            <se:Title>2.1.1. Otros cultivos transitorios</se:Title>
            <se:Abstract>2.1.1. Otros cultivos transitorios</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>211</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#ffffa6</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>2.1.2. Cereales</se:Name>
          <se:Description>
            <se:Title>2.1.2. Cereales</se:Title>
            <se:Abstract>2.1.2. Cereales</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>212</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#eee800</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>2.1.3. Oleaginosas y leguminosas</se:Name>
          <se:Description>
            <se:Title>2.1.3. Oleaginosas y leguminosas</se:Title>
            <se:Abstract>2.1.3. Oleaginosas y leguminosas</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>213</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#ffff5f</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>2.1.4. Hortalizas</se:Name>
          <se:Description>
            <se:Title>2.1.4. Hortalizas</se:Title>
            <se:Abstract>2.1.4. Hortalizas</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>214</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#e1d200</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>2.1.5. Tubérculos</se:Name>
          <se:Description>
            <se:Title>2.1.5. Tubérculos</se:Title>
            <se:Abstract>2.1.5. Tubérculos</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>215</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#d2cd00</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>2.2.1. Cultivos permanentes herbáceos</se:Name>
          <se:Description>
            <se:Title>2.2.1. Cultivos permanentes herbáceos</se:Title>
            <se:Abstract>2.2.1. Cultivos permanentes herbáceos</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>221</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#f2cca6</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>2.2.2. Cultivos permanentes arbustivos</se:Name>
          <se:Description>
            <se:Title>2.2.2. Cultivos permanentes arbustivos</se:Title>
            <se:Abstract>2.2.2. Cultivos permanentes arbustivos</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>222</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#f2a64d</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>2.2.3. Cultivos permanentes arbóreos</se:Name>
          <se:Description>
            <se:Title>2.2.3. Cultivos permanentes arbóreos</se:Title>
            <se:Abstract>2.2.3. Cultivos permanentes arbóreos</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>223</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#e6a600</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>2.2.4. Cultivos agroforestales</se:Name>
          <se:Description>
            <se:Title>2.2.4. Cultivos agroforestales</se:Title>
            <se:Abstract>2.2.4. Cultivos agroforestales</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>224</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#cc900a</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>2.2.5. Cultivos confinados</se:Name>
          <se:Description>
            <se:Title>2.2.5. Cultivos confinados</se:Title>
            <se:Abstract>2.2.5. Cultivos confinados</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>225</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#824a12</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>2.3.1. Pastos limpios</se:Name>
          <se:Description>
            <se:Title>2.3.1. Pastos limpios</se:Title>
            <se:Abstract>2.3.1. Pastos limpios</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>231</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#ccffcc</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>2.3.2. Pastos arbolados</se:Name>
          <se:Description>
            <se:Title>2.3.2. Pastos arbolados</se:Title>
            <se:Abstract>2.3.2. Pastos arbolados</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>232</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#9eff9e</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>2.3.3. Pastos enmalezados</se:Name>
          <se:Description>
            <se:Title>2.3.3. Pastos enmalezados</se:Title>
            <se:Abstract>2.3.3. Pastos enmalezados</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>233</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#9effc8</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>2.4.1. Mosaico de cultivos</se:Name>
          <se:Description>
            <se:Title>2.4.1. Mosaico de cultivos</se:Title>
            <se:Abstract>2.4.1. Mosaico de cultivos</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>241</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#ffe6a6</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>2.4.2. Mosaico de pastos y cultivos</se:Name>
          <se:Description>
            <se:Title>2.4.2. Mosaico de pastos y cultivos</se:Title>
            <se:Abstract>2.4.2. Mosaico de pastos y cultivos</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>242</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#ffd875</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>2.4.3. Mosaico de cultivos, pastos y espacios naturales</se:Name>
          <se:Description>
            <se:Title>2.4.3. Mosaico de cultivos, pastos y espacios naturales</se:Title>
            <se:Abstract>2.4.3. Mosaico de cultivos, pastos y espacios naturales</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>243</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#ffc941</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>2.4.4. Mosaico de pastos con espacios naturales</se:Name>
          <se:Description>
            <se:Title>2.4.4. Mosaico de pastos con espacios naturales</se:Title>
            <se:Abstract>2.4.4. Mosaico de pastos con espacios naturales</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>244</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#feb500</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>2.4.5. Mosaico de cultivos con espacios naturales</se:Name>
          <se:Description>
            <se:Title>2.4.5. Mosaico de cultivos con espacios naturales</se:Title>
            <se:Abstract>2.4.5. Mosaico de cultivos con espacios naturales</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>245</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#ffb03c</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>3.1.1. Bosque denso</se:Name>
          <se:Description>
            <se:Title>3.1.1. Bosque denso</se:Title>
            <se:Abstract>3.1.1. Bosque denso</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>311</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#478f00</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>3.1.2. Bosque abierto</se:Name>
          <se:Description>
            <se:Title>3.1.2. Bosque abierto</se:Title>
            <se:Abstract>3.1.2. Bosque abierto</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>312</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#55ab00</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>3.1.3. Bosque fragmentado</se:Name>
          <se:Description>
            <se:Title>3.1.3. Bosque fragmentado</se:Title>
            <se:Abstract>3.1.3. Bosque fragmentado</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>313</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#61c200</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>3.1.4. Bosque de galería y ripario</se:Name>
          <se:Description>
            <se:Title>3.1.4. Bosque de galería y ripario</se:Title>
            <se:Abstract>3.1.4. Bosque de galería y ripario</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>314</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#70e000</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>3.1.5. Plantación forestal</se:Name>
          <se:Description>
            <se:Title>3.1.5. Plantación forestal</se:Title>
            <se:Abstract>3.1.5. Plantación forestal</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>315</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#80ff00</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>3.2.1. Herbazal</se:Name>
          <se:Description>
            <se:Title>3.2.1. Herbazal</se:Title>
            <se:Abstract>3.2.1. Herbazal</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>321</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#ccf24e</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>3.2.2. Arbustal</se:Name>
          <se:Description>
            <se:Title>3.2.2. Arbustal</se:Title>
            <se:Abstract>3.2.2. Arbustal</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>322</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#acdb0f</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>3.2.3. Vegetación secundaria o en transición</se:Name>
          <se:Description>
            <se:Title>3.2.3. Vegetación secundaria o en transición</se:Title>
            <se:Abstract>3.2.3. Vegetación secundaria o en transición</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>323</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#96bf0d</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>3.3.1. Zonas arenosas naturales</se:Name>
          <se:Description>
            <se:Title>3.3.1. Zonas arenosas naturales</se:Title>
            <se:Abstract>3.3.1. Zonas arenosas naturales</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>331</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#c2c2c2</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>3.3.2. Afloramientos rocosos</se:Name>
          <se:Description>
            <se:Title>3.3.2. Afloramientos rocosos</se:Title>
            <se:Abstract>3.3.2. Afloramientos rocosos</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>332</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#b3b3b3</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>3.3.3. Tierras desnudas y degradadas</se:Name>
          <se:Description>
            <se:Title>3.3.3. Tierras desnudas y degradadas</se:Title>
            <se:Abstract>3.3.3. Tierras desnudas y degradadas</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>333</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#9e9e9e</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>3.3.4. Zonas quemadas</se:Name>
          <se:Description>
            <se:Title>3.3.4. Zonas quemadas</se:Title>
            <se:Abstract>3.3.4. Zonas quemadas</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>334</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#898989</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>3.3.5. Zonas glaciares y nivales</se:Name>
          <se:Description>
            <se:Title>3.3.5. Zonas glaciares y nivales</se:Title>
            <se:Abstract>3.3.5. Zonas glaciares y nivales</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>335</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#6565b4</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>4.1.1. Zonas pantanosas</se:Name>
          <se:Description>
            <se:Title>4.1.1. Zonas pantanosas</se:Title>
            <se:Abstract>4.1.1. Zonas pantanosas</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>411</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#a6a6ff</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>4.1.2. Turberas</se:Name>
          <se:Description>
            <se:Title>4.1.2. Turberas</se:Title>
            <se:Abstract>4.1.2. Turberas</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>412</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#4d91ff</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>4.1.3. Vegetación acuática sobre cuerpos de agua</se:Name>
          <se:Description>
            <se:Title>4.1.3. Vegetación acuática sobre cuerpos de agua</se:Title>
            <se:Abstract>4.1.3. Vegetación acuática sobre cuerpos de agua</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>413</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#5050ff</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>4.2.1. Pantanos costeros</se:Name>
          <se:Description>
            <se:Title>4.2.1. Pantanos costeros</se:Title>
            <se:Abstract>4.2.1. Pantanos costeros</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>421</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#ccccff</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>4.2.2. Salitral</se:Name>
          <se:Description>
            <se:Title>4.2.2. Salitral</se:Title>
            <se:Abstract>4.2.2. Salitral</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>422</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#b7b7ff</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>4.2.3. Sedimentos expuestos en bajamar</se:Name>
          <se:Description>
            <se:Title>4.2.3. Sedimentos expuestos en bajamar</se:Title>
            <se:Abstract>4.2.3. Sedimentos expuestos en bajamar</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>423</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#a6a6e6</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>5.1.1. Ríos</se:Name>
          <se:Description>
            <se:Title>5.1.1. Ríos</se:Title>
            <se:Abstract>5.1.1. Ríos</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>511</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#0000f8</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>5.1.2. Lagunas, lagos y ciénagas naturales</se:Name>
          <se:Description>
            <se:Title>5.1.2. Lagunas, lagos y ciénagas naturales</se:Title>
            <se:Abstract>5.1.2. Lagunas, lagos y ciénagas naturales</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>512</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#0080ff</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>5.1.3. Canales</se:Name>
          <se:Description>
            <se:Title>5.1.3. Canales</se:Title>
            <se:Abstract>5.1.3. Canales</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>513</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#00b2ff</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>5.1.4. Cuerpos de agua artificiales</se:Name>
          <se:Description>
            <se:Title>5.1.4. Cuerpos de agua artificiales</se:Title>
            <se:Abstract>5.1.4. Cuerpos de agua artificiales</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>514</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#00cef2</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>5.2.1. Lagunas costeras</se:Name>
          <se:Description>
            <se:Title>5.2.1. Lagunas costeras</se:Title>
            <se:Abstract>5.2.1. Lagunas costeras</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>521</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#45e0f5</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>5.2.3. Estanques para acuicultura marina</se:Name>
          <se:Description>
            <se:Title>5.2.3. Estanques para acuicultura marina</se:Title>
            <se:Abstract>5.2.3. Estanques para acuicultura marina</se:Abstract>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:PropertyIsEqualTo>
              <ogc:Function name="left">
                <ogc:Function name="to_string">
                  <ogc:PropertyName>codigo</ogc:PropertyName>
                </ogc:Function>
                <ogc:Literal>3</ogc:Literal>
              </ogc:Function>
              <ogc:Literal>523</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#ccf6ff</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>&lt;all other values&gt;</se:Name>
          <se:Description>
            <se:Title>&lt;all other values&gt;</se:Title>
            <se:Abstract>&lt;all other values&gt;</se:Abstract>
          </se:Description>
          <se:ElseFilter xmlns:se="http://www.opengis.net/se"/>
          <se:PolygonSymbolizer>
            <se:Fill>
              <se:SvgParameter name="fill">#cabff2</se:SvgParameter>
            </se:Fill>
          </se:PolygonSymbolizer>
        </se:Rule>
      </se:FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>
