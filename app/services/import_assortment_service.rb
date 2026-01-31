require 'csv'

class ImportAssortmentService
  def initialize(brand, file)
    @brand = brand
    @file = file
    @report = { success: 0, errors: [] }
  end

  def call
    # On utilise col_sep: nil pour que Ruby tente de deviner si c'est , ou ;
    CSV.foreach(@file.path, headers: true, col_sep: ';') do |row|
      process_row(row)
    end
    @report
  end

  private

  def process_row(row)
    # Pour l'instant on part sur des colonnes standards
    # On affinera ces noms (ex: 'ean', 'strate') quand tu auras le fichier
    ean = row['ean']&.strip
    stratum_name = row['strate']&.strip

    return if ean.blank?

    product = Product.find_by(ean: ean)
    unless product
      @report[:errors] << "EAN inconnu : #{ean}"
      return
    end

    # Si la colonne strate est vide, on peut décider de supprimer ou d'ignorer
    if stratum_name.blank?
      return
    end

    # Gestion du "H1 H2" (on sépare par espace ou virgule)
    strata_names = stratum_name.split(/[\s,]+/)

    strata_names.each do |s_name|
      stratum = @brand.strata.where('lower(name) = ?', s_name.downcase.strip).first

      if stratum
        assortment = Assortment.find_or_initialize_by(brand: @brand, product: product, stratum: stratum)
        if assortment.save
          @report[:success] += 1
        end
      else
        @report[:errors] << "Strate '#{s_name}' non trouvée pour le produit #{product.name}"
      end
    end
  end
end
