class ProductsController < AuthenticatedController
    
    def index
        @products = ShopifyAPI::Product.find(:all, :params => {:limit => 10})
    end
    
    def edit
        @product = ShopifyAPI::Product.find(params[:id])
        @product_variants = PriceCountriesProductVariant.where(:product_id => @product.id)
    end
    
    def generate_variant
        # option1: currency
        # option2: country
        product = ShopifyAPI::Product.find(params[:id])
        params[:variants].each do |variant|
            params_variant = variant[1]
            @variant = ShopifyAPI::Variant.new(product_id: product.id, option1: params_variant[:currency], price: params_variant[:price].to_f )
            if @variant.save
                price_countries_product_variants = PriceCountriesProductVariant.new(name: params_variant[:name_country], price: params_variant[:price].to_f, currency: params_variant[:currency], variant_id: @variant.id, product_id: product.id )
                price_countries_product_variants.save
            end
        end
        respond_to do |format|
            # format.html {redirect_to product_path}
            format.js { render json: {  } }
        end
    end
    
    def destroy_product_variant
        @variant = ShopifyAPI::Variant.find(params[:id])
        @variant.destroy
        respond_to do |format|
            # format.html {redirect_to product_path}
            format.js { render json: { id: @variant.id } }
        end
    end
    
    def edit_product_variant
        binding.pry
        # product = ShopifyAPI::Product.find(params[:id_product])
        params_variant = params[:variant]
        variant = ShopifyAPI::Variant.update(variant_id: params_variant[:product_variant_id], option1: params_variant[:currency], price: params_variant[:price].to_f )
            if variant.save
                price_countries_product_variants = PriceCountriesProductVariant.update(name: params_variant[:name_country], price: params_variant[:price].to_f, currency: params_variant[:currency], variant_id: variant.id )
                if price_countries_product_variants.save
                    respond_to do |format|
                        # format.html {redirect_to product_path}
                        format.js { render json: { id: variant.id } }
                    end
                end
            end
    end

    
end
