module RDFDoubles
  def literal(value, options = { class: 'RDF::Literal' })
    double(options[:class]).tap do |literal|
      allow(literal).to receive(:to_s).and_return(value)
    end
  end

  def uri(value, options = { class: 'RDF::URI' })
    literal(value, options)
  end
end
