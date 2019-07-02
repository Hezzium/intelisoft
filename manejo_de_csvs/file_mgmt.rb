# Estas son librerias incluidas
require 'pry'       # Nos ayuda con REPL Y debugging
require 'csv'       # Nos ayuda con CSV

# ####### Metodos Utilitarios #############
def to_csv(array_de_hashes)
  CSV.open("csv_salida/acumulado.csv", "wb") do |csv|
    csv << array_de_hashes.first.keys # Agrega las keys como cabeceras
    array_de_hashes.each do |hash|
      csv << hash.values
    end
  end
end

def csv_to_dictionario(ruta_a_csv)
  CSV.read(ruta_a_csv, headers: true, header_converters: :symbol)
end
# #########################################

colector_de_csv = []
rutas = Dir["csv_entrada/*.csv"]

# Aca iteramos sobre rutas y por cada nombre de archivo corremos el proceso
rutas.each do |ruta|
  p "############# Inicio :: #{ruta} ###############"
  CSV.foreach(ruta, headers: :first_row) do |row|
    colector_de_csv << row.to_hash
  end
end

# Paso Final: para la informacion a un CSV
to_csv(colector_de_csv)