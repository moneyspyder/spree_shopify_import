class ShopifyImporter

  MAPPING = {
    "Handle" => :slug,
    "Title" => :name,
    "SEO Description" => :meta_description,
    "Variant Price" => :price,
    "Body (HTML)" => :description
  }
  
  # TODO Add a log of the import
  def self.import(file)
    
    CSV.foreach(file, headers: true) do |row|
      shopify_hash = Hash[*row.headers.zip(row.fields).flatten]
      spree_hash = Hash[*MAPPING.collect { |key,value| [value, shopify_hash[key]] }.flatten]
      spree_hash[:shipping_category_id] = Spree::ShippingCategory.first.id
      unless Spree::Product.where(slug: spree_hash[:slug]).exists?
        Spree::Product.create(spree_hash)
      else
        product = Spree::Product.find_by_slug(spree_hash[:slug])
        product.description = spree_hash[:description] unless spree_hash[:description].blank?
        product.save
      end
    end
  end

end