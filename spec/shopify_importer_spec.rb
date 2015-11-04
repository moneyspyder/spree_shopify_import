require 'spec_helper'

describe ShopifyImporter do

  describe '.import' do

    describe 'using with file containing 1 product' do

      it 'creates 1 spree product' do
        ShopifyImporter.import 'as'
      end

    end

  end

end
