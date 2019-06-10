# Instalar gem para XML
# Leer factura
# Ver objeto
# 1 crear nombre de archivo
# 2 crear registro en csv codigo mas otros
# 3 mover a carpeta out
# Saltarse


# Estas son librerias incluidas
require 'nokogiri' # Nos ayuda con XML parsing
require 'pry'      # Nos ayuda con REPL Y debugging
require 'csv'      # Nos ayuda con CSV
require 'fileutils'


tde_incluidos =    ["33", "34", "52","56", "61"]
rut_emisor_block = "123-k"
final_rows =       []

# La variable rutas va a ser un array con string adentro.
# Tipos de data hay varios, numbers, strings, arrays, hashes
# numbers = 1, 2, 1.5, 0000.5  (integers vs floats)
# strings = 'a', 'b', 'JP va a ser un buen ingeniero en software'
# array = ['a', 'b']

rutas = Dir["facturas_entrada/*.xml"]
# => ['nombre_arechivo_1.xml', 'nombre_arechivo_2.xml', 'nombre_arechivo_3.xml']


libro_compras_hash = csv_to_dictionario_codico("libro_compras/libro_compras.csv")


# Aca iteramos sobre rutas y por cada nombre de archivo corremos el proceso
rutas.each do |c|

  # 1: Abre el archivo XML para poder leerlo
  doc = Nokogiri::XML.parse(File.open(ruta))

  # Begin sirve para hacer que si el proceso tira un error no pare la iteracion
  begin
    tipo_dte = doc.xpath('//xmlns:TipoDTE').children.text
    rut_emisor = doc.xpath('//xmlns:RUTEmisor').children.text

    if rut_emisor != rut_emisor_block && tde_incluidos.include?(tipo_dte)
      folio = doc.xpath('//xmlns:Folio').children.text
      codigo = "#{rut_emisor}#{tipo_dte}#{folio}"

      return nil unless libro_compras_hash[codigo].present?

      correlativo_doc = libro_compras_hash[codigo]

      row_info = {
        tipo_dte: tipo_dte,
        rut_emisor: rut_emisor,
        folio: folio,
        codigo: codigo,
        correlativo_doc: correlativo_doc
      }

      final_rows << row_info
      FileUtils.mv(ruta, "facturas_salida/#{codigo}-#{correlativo_doc}")
    end
  end
end


# Final step
to_csv(final_rows)


# Utility methods

def to_csv(array_de_hashes)
  # Trun this into a csv
end

def csv_to_dictionario_codico(ruta_a_csv)
  # Hacer el CSV libro compras dispobible
  libro_compras = CSV.read(ruta_a_csv, headers: true, header_converters: :symbol)
  libro_compras_hash = {}
  libro_compras.each {|row| libro_compras_hash[row[:codigo]] = row[:correlativo_doc] }
end
