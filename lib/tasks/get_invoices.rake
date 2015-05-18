namespace :invoices do
desc "get all invoices for major distributors on a chart"
  task :by_distributor => :environment do 

    File.open(Rails.root.join("public","invoices.html"),"w") do |outfile| 
    
    outfile.write(File.open(Rails.root.join("public","invoices_top.html")).read)



    big_distributors=Distributor.all.find_all {|d| d.purchase_orders.where(:ordered=>true).length >= 2}
    
    distributors_to_invoices={}
    
    big_distributors.each do |distributor|
      
      invoices=[]
      
      distributor.invoices.where(:received=>true).each do |i| 
        total=i.total_cost+i.shipping_cost 
        sales_to_date=i.sales_to_date 
        returns_to_date=i.returns_to_date
        invoice_net=sales_to_date-(total-returns_to_date)
        invoices.append([i.received_when.to_time.to_i,invoice_net.to_f])
      end
      
      distributors_to_invoices[distributor]=invoices
    end
    
    
      outfile.write(distributors_to_invoices.collect {|k,v| "{ name: '#{k.name.gsub(/[^0-9a-z]/i, '')}', data: #{v}}"}.join ",")
      outfile.write(File.open(Rails.root.join("public","invoices_bottom.html")).read)  


    end
  end						   	      
end							      

