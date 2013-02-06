class FormCreator
  attr_accessor :model, :attributes, :btns
  def initialize(model)
    @model = model
    @attributes = []
  end
  
  def item(type, attribute, *args)
    attributes << FormItem.new(type, attribute, model, args)
  end
  
  def custom(&block)
    attributes << block
  end
  
  
  def buttons(submit_text, back_url)
    @btns = [submit_text, back_url]
  end
  
  
  class FormItem
    require 'ostruct'
    attr_accessor :type, :name, :args, :options
    def initialize(type, attribute, model, args)
      @type = type
      @name = attribute
      opts = {:label => true, :required => false, :hint => false}
      newopts = {}
      args.each do |val|
        unless val.is_a? Hash
          newopts[val] = true
        else
          newopts.merge! val
        end
      end
      
    opts.merge! newopts
    @options = OpenStruct.new(opts)
      
    end
  end

end
