# This is the module containing the Scufl model implementation i.e. the model structure/definition and all its internals.

module Scufl # :nodoc:
  
  # The model for a given Taverna 1 workflow.
  class Model
    # This returns a WorkflowDescription object.
    attr_reader :description
    
    # Retrieve the list of processors specific to the workflow.
    # Does not include those from nested workflows.
    attr_reader :processors
    
    # Retrieve the list of datalinks specific to the workflow.
    # Does not include those from nested workflows.
    attr_reader :links
    
    # Retrieve the list of sources specific to the workflow.
    # Does not include those from nested workflows.
    attr_reader :sources
    
    # Retrieve the list of sinks specific to the workflow.
    # Does not include those from nested workflows.
    attr_reader :sinks
    
    # Retrieve the list of coordinations specific to the workflow.
    # Does not include those from nested workflows.
    attr_reader :coordinations
    
    # The list of any dependencies that have been found inside the workflow.
    # Does not include those from nested workflows.
    attr_accessor :dependencies
    
    # Creates an empty model for a Taverna 1 workflow.
    def initialize
      @description = WorkflowDescription.new
      @processors = Array.new
      @links = Array.new
      @sources = Array.new
      @sinks = Array.new
      @coordinations = Array.new
    end
    
    # Retrieve ALL the beanshell processors within the workflow.
    def beanshells
      return get_beanshells(self, [])
    end
    
    private
    
    def get_beanshells(given_model, beans_collected) # :nodoc:
      wf_procs = given_model.processors.select { |x| x.type == "workflow" }
      wf_procs.each { |x| get_beanshells(x.model, beans_collected) if x.model }
      
      bean_procs = given_model.processors.select { |b| b.type == "beanshell" }
      bean_procs.each { |a| beans_collected << a }
      
      return beans_collected
    end
  end
  
  
  
  # This is the (shim) object within the workflow.  This can be a beanshell,
  # a webservice, a workflow, etc...
  class Processor
    # A string containing name of the processor.
    attr_accessor :name 
    
    # A string containing the description of the processor if available.  
    # Returns nil otherwise.
    attr_accessor :description
    
    # A string for the type of processor, e.g. beanshell, workflow, webservice, etc...
    attr_accessor :type 
    
    # For processors that have type == "workflow", model is the the workflow 
    # definition.  For all other processor types, model is nil.
    attr_accessor :model
    
    # This only has a value in beanshell processors.  This is the actual script
    # embedded with the processor which does all the "work"
    attr_accessor :script
    
    # This is a list of inputs that the processor can take in.
    attr_accessor :inputs
    
    # This is a list of outputs that the processor can produce.
    attr_accessor :outputs
    
    # For processors of type "arbitrarywsdl", this is the URI to the location
    # of the wsdl file.
    attr_accessor :wsdl
    
    # For processors of type "arbitrarywsdl", this is the operation invoked.
    attr_accessor :wsdl_operation
    
    # For soaplab and biomoby services, this is the endpoint URI.
    attr_accessor :endpoint
    
    # Authority name for the biomoby service.
    attr_accessor :biomoby_authority_name

    # Service name for the biomoby service. This is not necessarily the same 
    # as the processors name.
    attr_accessor :biomoby_service_name
    
    # Category for the biomoby service.
    attr_accessor :biomoby_category
  end


  
  # This contains basic descriptive information about the workflow model.
  class WorkflowDescription
    # The author of the workflow.
    attr_accessor :author
    
    # The name/title of the workflow.
    attr_accessor :title
    
    # A small piece of descriptive text for the workflow.
    attr_accessor :description
  end

  
  
  # This represents a connection between any of the following pair of entities:
  # {processor -> processor}, {workflow -> workflow}, {workflow -> processor}, 
  # and {processor -> workflow}.
  class Link
    # The name of the source (the starting point of the connection).
    attr_accessor :source
    
    # The name of the sink (the endpoint of the connection).
    attr_accessor :sink
  end



  # This is a representation of the 'Run after...' function in Taverna
  # where the selected processor or workflow is set to run after another.
  class Coordination
    # The name of the processor/workflow which is to run first.
    attr_accessor :controller
    
    # The name of the processor/workflow which is to run after the controller.
    attr_accessor :target
  end

  
  
  # This is the start node of a Link.  Each source has a name and a port
  # which is seperated by a colon; ":".
  # This is represented as "source of a processor:port_name".
  # A string that does not contain a colon can often be returned, signifiying
  # a workflow source as opposed to that of a processor.
  class Source
  	attr_accessor :name, :description
  end
  
  
  
  # This is the start node of a Link.  Each sink has a name and a port
  # which is seperated by a colon; ":".
  # This is represented as "sink of a processor:port_name".
  # A string that does not contain a colon can often be returned, signifiying
  # a workflow sink as opposed to that of a processor.
  class Sink
	  attr_accessor :name, :description
  end  	
  
end
