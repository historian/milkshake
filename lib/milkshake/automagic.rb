module Rails
  
  require 'milkshake'
  
  def self.pick_boot
    Milkshake::BundlerBoot.new
  end
  
end