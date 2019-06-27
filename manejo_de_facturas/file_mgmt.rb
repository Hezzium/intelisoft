# Estas son librerias incluidas
require 'nokogiri'  # Nos ayuda con XML parsing
require 'pry'       # Nos ayuda con REPL Y debugging
require 'csv'       # Nos ayuda con CSV
require 'fileutils' # Nos ayuda con manejo de archivos (mover a nueva carpeta)

# ####### Metodos Utilitarios #############
def to_csv(array_de_hashes)
  CSV.open("resultado.csv", "wb") do |csv|
    csv << array_de_hashes.first.keys # Agrega las keys como cabeceras
    array_de_hashes.each do |hash|
      csv << hash.values
    end
  end
end

def csv_to_dictionario_codico(ruta_a_csv)
  # Hacer el CSV libro compras dispobible
  libro_compras = CSV.read(ruta_a_csv, headers: true, header_converters: :symbol)
  libro_compras_hash = {}
  libro_compras.each {|row| libro_compras_hash[row[:codigo]] = row[:correlativo_doc] }
  libro_compras_hash
end

def obtener_rut_emisor(mapa_de_campos_relevantes)
  mapa_de_campos_relevantes["RutEmisor"] || mapa_de_campos_relevantes["RUTEmisor"]
end
# #########################################

tde_incluidos =    ["33", "34", "52","56", "61"]
rut_emisor_block = "85956200-0"
final_rows =       []

campos_relevantes = [
  "RutEmisor",
  "RutReceptor",
  "TpoDTE",
  "NroDTE",
  "Documento",
  "Folio",
  "FchEmis",
  "RznSoc",
  "GiroEmis",
  "Sucursal",
  "DirOrigen",
  "CmnaOrigen",
  "MntNeto",
  "MntExe",
  "TasaIVA",
  "IVA",
  "MntTotal",
  "NroLinDet",
  "TpoCodigo",
  "VlrCodigo",
  "NmbItem",
  "DscItem",
  "QtyItem",
  "PrcItem",
  "MontoItem",
  "Detalle",
  "NroLinDet",
  "CdgItem",
  "TpoCodigo",
  "VlrCodigo",
  "NmbItem",
  "DscItem",
  "QtyItem",
  "PrcItem",
  "MontoItem",
  "NroLinRef",
  "TpoDocRef",
  "FolioRef",
  "FchRef",
  "TpoDocRef",
  "FolioRef",
  "FchRef"
]

# La variable `rutas` va a ser un array con string adentro.
# Tipos de data hay varios, numbers, strings, arrays, hashes
# numbers = 1, 2, 1.5, 0000.5  (integers vs floats)
# strings = 'a', 'b', 'JP va a ser un buen ingeniero en software'
# array = ['a', 'b']

rutas = Dir["facturas_entrada/*.xml"]
# rutas = ['facturas_entrada/nombre_arechivo_1.xml', 'facturas_entrada/nombre_arechivo_2.xml', 'facturas_entrada/nombre_arechivo_3.xml']

libro_compras_hash = csv_to_dictionario_codico("libro_compras/libro_compras.csv")
# libro_compras_hash = {
#  "10459350-K3339"=>"19 01 0470",
#  "10729815-033101"=>"19 01 0178",
#  "10935819-3331352"=>"19 01 0280",
#  "11370765-8332853"=>"19 01 0304",
#   ...
# }

# Aca iteramos sobre rutas y por cada nombre de archivo corremos el proceso
rutas.each do |ruta|

  p "############# Inicio :: #{ruta} ###############"

  # 1: Abre el archivo XML para poder leerlo
  doc = Nokogiri::XML.parse(File.open(ruta))

  # 2: Mapea los campos relevantes para acceder a la informacion del XML
  mapa_de_campos_relevantes = {}
  campos_relevantes.each do |campo|
    # Begin sirve para hacer que si el proceso tira un error no pare la iteracion
    begin
      mapa_de_campos_relevantes[campo] = doc.xpath("//xmlns:#{campo}").children.text
    end
  end

  # Resultado de ete paso:
  # mapa_de_campos_relevantes = {
  #   "RUTEmisor":  "Valor de este campo"
  #   "Folio":      "Valor de este campo"
  #   "FchRef":     "Valor de este campo"
  # }

  # 3: Obtiene rut emisor
  rut_emisor = obtener_rut_emisor(mapa_de_campos_relevantes)

  # 4: Verifica que el rut emisor sea valido y que el tipo de documento sea
  #    relevante
  if rut_emisor != rut_emisor_block && tde_incluidos.include?(mapa_de_campos_relevantes["TpoDTE"])

    p ""
    p "Procesando"
    p "Rut emisor: #{rut_emisor}"
    p "Tipo de documento: #{mapa_de_campos_relevantes["TpoDTE"]}"
    p ""

    # 5: Arma el codigo con la infomacion necesaria
    codigo = "#{rut_emisor}#{mapa_de_campos_relevantes["TpoDTE"]}#{mapa_de_campos_relevantes["Folio"]}"
    correlativo_doc = libro_compras_hash[codigo]

    # 6: Si el correlativo es encontrado en el libro de compras
    unless correlativo_doc.nil?

      p ""
      p "Correlativo encontrado: #{correlativo_doc}"
      p "Creando registro en CSV y moviendo .XML a carpeta salida"
      p ""

      # 6.1: Agrega correlativo y crea un registo para luego pasarlo a CSV
      mapa_de_campos_relevantes['correlativo_doc'] = correlativo_doc
      final_rows << mapa_de_campos_relevantes

      # 6.1: Mueve el archivo de carpeta y le cambia el nombre
      FileUtils.mv(ruta, "facturas_salida/#{codigo}-#{correlativo_doc}")
    end
  end

  p "############# Fin :: #{ruta} ###############"
  p "############# ############## ###############"
  p ""
end

# Paso Final: para la informacion a un CSV
to_csv(final_rows)