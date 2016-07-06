module DfidTransition
  module Transform
    module Themes
      def transform_to_label_value(r4d_solutions)
        r4d_solutions.map do |solution|
          theme_slug = parameterize(solution['theme'].to_s)

          {
            value: theme_slug,
            label: solution['prefLabel'].to_s
          }
        end
      end

      def parameterize(theme_url)
        theme_url.
          sub(%r{http://.*#}, ''). # Strip http://....#
        gsub('%20', '_').          # underscore escaped spaces
        downcase
      end
    end
  end
end

