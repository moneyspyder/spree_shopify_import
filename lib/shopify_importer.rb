class ShopifyImporter

  MAPPING = {
    "Title" => :name,
    "SEO Description" => :meta_description,
    "Variant Price" => :price
  }
  

  def self.import(file)
    CSV.foreach(file, headers: true) do |row|
      shopify_hash = Hash[*row.headers.zip(row.fields).flatten]
      spree_hash = Hash[*MAPPING.collect { |key,value| [value, shopify_hash[key]] }.flatten]
      spree_hash[:shipping_category_id] = Spree::ShippingCategory.first.id
      Spree::Product.create(spree_hash)
    end
  end

end