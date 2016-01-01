require 'spec_helper'

describe ShopifyImporter do

  describe '.import' do

    before(:each) do
      Spree::ShippingCategory.create(name: 'Default Shipping Category')
    end

    describe 'using with file containing 1 product' do

      let(:file) do
        File.open(
          File.join('spec', 'data', 'products_export.csv')
        )
      end

      it 'creates 1 spree product' do
        expect{
          ShopifyImporter.import file
        }.to change{
          Spree::Product.count
        }.from(0).to(1)
      end

    end

    product_description = '<p>These stunning clear opal vases were designed to represent the 7 days of the week</p>'

    describe %Q{file contains handle "7-days-vases" with description "#{product_description}"} do

      context 'product exists with a slug "7-days-vases" but without a description' do

        let(:file) do
          File.open(
            File.join('spec', 'data', 'products_export.csv')
          )
        end

        let(:default_shipping_category) do
          Spree::ShippingCategory.create(:name => 'Default Shipping')
        end

        let(:product) do
          default_attrs = {
            :available_on => Time.zone.now,
            :shipping_category => default_shipping_category,
            :price => 14.99,
            :name => '7 Days Vases',
            :slug => '7-days-vases'
          }
          result = Spree::Product.create!(default_attrs)
          result.shipping_category = default_shipping_category
          result.save!
          result
        end

        it %Q{changes the description to "#{product_description}"} do
          expect{
            ShopifyImporter.import file
          }.to change{
            Spree::Product.find(product).description
          }.from(nil).to(product_description)
        end

      end      

    end

  end

end
