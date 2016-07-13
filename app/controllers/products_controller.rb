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
    _gbp_rate = JSON.parse(open("db/currency_rates.txt").read)["GBP"]
    product = ShopifyAPI::Product.find(params[:id])
    params[:variants].each do |variant|
      params_variant = variant[1]
      @region = Region.find(params_variant[:region_id])
      if params_variant["currency"] == "EURO"
        @variant = ShopifyAPI::Variant.new(product_id: product.id, option1: @region.name, price: params_variant[:price].to_f )
        if @variant.save
          price_countries_product_variants = PriceCountriesProductVariant.new(region_id: params_variant[:region_id], price: params_variant[:price].to_f, 
                                                                              currency: params_variant[:currency], variant_id: @variant.id, product_id: product.id )
          price_countries_product_variants.save
        end
      elsif params_variant["currency"] == "STG"
        price_in_euros = (params_variant["price"].to_f / _gbp_rate).round(2)
        @variant = ShopifyAPI::Variant.new(product_id: product.id, option1: @region.name, price: price_in_euros )
        if @variant.save
          price_countries_product_variants = PriceCountriesProductVariant.new(region_id: params_variant[:region_id], price: params_variant[:price].to_f, currency: params_variant[:currency], 
                                                                              variant_id: @variant.id, product_id: product.id, price_in_euros: price_in_euros )
          price_countries_product_variants.save
        end
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
      format.js { render json: { id: @price_countries_product_variant.id } }
    end
  end
  
  def update_product_variant
    _gbp_rate = JSON.parse(open("db/currency_rates.txt").read)["GBP"]
    params_variant = params[:variant]
    @region = Region.find params_variant["region_id"]
    @price_countries_product_variant = PriceCountriesProductVariant.find(params[:price_countries_product_variant_id])
    @variant = ShopifyAPI::Variant.find(@price_countries_product_variant.variant_id)
    if params_variant["currency"] == "EURO"
      if @variant.update_attributes(price: params_variant[:price].to_f, option1: @region.name)
        if @price_countries_product_variant.update_attributes(region_id: params_variant[:region_id], price: params_variant[:price].to_f, currency: params_variant[:currency])
          respond_to do |format|
            format.js { render json: { id: @price_countries_product_variant.id } }
          end
        end
      end
    elsif params_variant["currency"] == "STG"
      price_in_euros = (params_variant["price"].to_f / _gbp_rate).round(2)
      if @variant.update_attributes(price: price_in_euros, option1: @region.name)
        if @price_countries_product_variant.update_attributes(region_id: params_variant[:region_id], price: params_variant[:price].to_f, 
                                                              currency: params_variant[:currency], price_in_euros: price_in_euros)
          respond_to do |format|
            format.js { render json: { id: @price_countries_product_variant.id } }
          end
        end
      end
    end
  end
end
