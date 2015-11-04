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

  end

end
