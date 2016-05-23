class ProductsController < AuthenticatedController
    
  def index
    @products = ShopifyAPI::Product.find(:all, :params => {:limit => 10})
  end
  
  def edit
    @product = ShopifyAPI::Product.find(params[:id])
    @product_variants = PriceCountriesProductVariant.where(:product_id => @product.id)
    @regions = Region.all
  end
  
  def generate_variant
    product = ShopifyAPI::Product.find(params[:id])
    params[:variants].each do |variant|
      params_variant = variant[1]
      @region = Region.find(params_variant[:region_id])
      @variant = ShopifyAPI::Variant.new(product_id: product.id, option1: @region.name, price: params_variant[:price].to_f )
      if @variant.save
        price_countries_product_variants = PriceCountriesProductVariant.new(region_id: params_variant[:region_id], price: params_variant[:price].to_f, currency: params_variant[:currency], variant_id: @variant.id, product_id: product.id )
        price_countries_product_variants.save
      end
    end
    respond_to do |format|
      # format.html {redirect_to product_path}
      format.js { render json: {  } }
    end
  end
  
  def destroy_product_variant
    @price_countries_product_variant = PriceCountriesProductVariant.find(params[:id])
    @variant = ShopifyAPI::Variant.find(@price_countries_product_variant.variant_id)
    
    @variant.destroy
    @price_countries_product_variant.destroy
    respond_to do |format|
      # format.html {redirect_to product_path}
      format.js { render json: { id: @price_countries_product_variant.id } }
    end
  end
  
  def update_product_variant
    
    params_variant = params[:variant]
    @price_countries_product_variant = PriceCountriesProductVariant.find(params[:price_countries_product_variant_id])
    @variant = ShopifyAPI::Variant.find(@price_countries_product_variant.variant_id)
    if @variant.update_attributes(price: params_variant[:price].to_f)
      if @price_countries_product_variant.update_attributes(region_id: params_variant[:region_id], price: params_variant[:price].to_f, currency: params_variant[:currency])
        respond_to do |format|
          # format.html {redirect_to product_path}
          format.js { render json: { id: @price_countries_product_variant.id } }
        end
      end
    end
  end
end
