class ProductsController < AuthenticatedController
    
    def index
        @products = ShopifyAPI::Product.find(:all, :params => {:limit => 10})
    end
    
    def show
        @product = ShopifyAPI::Product.find(params[:id])
    end
    
end
