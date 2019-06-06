# Instalar gem para XML
# Leer factura
# Ver objeto
# 1 crear nombre de archivo
# 2 crear registro en csv codigo mas otros
# 3 mover a carpeta out
# Saltarse

require 'nokogiri'
require 'pry'

tde_incluidos = ["33", "34", "52","56", "61"]
rutas = Dir["facturas_entrada/*.xml"]

rutas.each do |ruta|
  doc = Nokogiri::XML.parse(File.open(ruta))

  begin
    tipo_dte = doc.xpath('//xmlns:TipoDTE').children.text
    if tde_incluidos.include?(tipo_dte)
      p rut_emisor = doc.xpath('//xmlns:RUTEmisor').children.text
      p folio = doc.xpath('//xmlns:Folio').children.text

      p codigo = "#{rut_emisor}#{tipo_dte}#{folio}"
    end
  end
end
