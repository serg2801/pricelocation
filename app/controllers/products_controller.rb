class ProductsController < AuthenticatedController
    
    def index
        @products = ShopifyAPI::Product.find(:all, :params => {:limit => 10})
    end
    
    def edit
        @product = ShopifyAPI::Product.find(params[:id])
        @product_variants = @product.variants
    end
    
    def generate_variant
        @product = ShopifyAPI::Product.find(params[:id])
        params[:variants].each do |variant|
            @params_variant = variant[1]
            @variant = ShopifyAPI::Variant.new(product_id: @product.id, option1: @params_variant[:currency], option2: @params_variant[:name_country], price: @params_variant[:price].to_i )
            if @variant.save
                @price_countries_product_variants = PriceCountriesProductVariant.new(name: @params_variant[:name_country], price: @params_variant[:price].to_i, currency: @params_variant[:currency], variant_id: @variant.id )
                @price_countries_product_variants.save
            end
        end
        redirect_to products_path
    end
    
    def destroy_product_variant
        binding.pry
        @variant = ShopifyAPI::Variant.find(params[:id])
        @variant.destroy
        respond_to do |format|
            # format.html {redirect_to product_path}
            format.js { render json: { id: @variant.id } }
        end
    end
    
    def edit_product_variant
    end

    
end
