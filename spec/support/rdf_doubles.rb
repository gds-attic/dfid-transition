module RDFDoubles
  def literal(value, options = { class: 'RDF::Literal' })
    double(options[:class]).tap do |literal|
      allow(literal).to receive(:to_s).and_return(value)
      allow(literal).to receive(:to_str).and_return("#{options[:class]}: #{value}")
    end
  end

  def uri(value, options = { class: 'RDF::URI' })
    literal(value, options)
  end

  def boolean(value)
    double('RDF::Literal::Boolean').tap do |boolean|
      allow(boolean).to receive(:true?).and_return(value)
      allow(boolean).to receive(:false?).and_return(!value)
    end
  end

  class Solution
    def initialize(value_hash)
      @value_hash = value_hash
    end

    def [](index)
      @value_hash[index.to_s] || @value_hash[index.to_sym]
    end
  end

  class Query < Struct.new(:solutions)
  end
end
