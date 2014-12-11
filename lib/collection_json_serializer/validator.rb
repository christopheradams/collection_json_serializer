module CollectionJson
  class Serializer
    class Validator
      include CollectionJson::Serializer::Support

      attr_accessor :errors

      def initialize(serializer)
        @serializer = serializer
        @errors = {}
        validate
      end

      def valid?
        !invalid?
      end

      def invalid?
        @errors.any?
      end

      private

      def validate
        [
          :attributes,
          :href,
          :links,
          :template
        ].each { |m| send("validate_#{m}") }
      end

      def validate_attributes
        @serializer.attributes.each do |attr|
          params = attr.extract_params

          if value_is_invalid? extract_value_from(@serializer, params[:name])
            error_for :value, root: :attributes, path: [params[:name]]
          end

          params[:properties].each do |key, value|
            if value_is_invalid? value
              error_for :value, root: :attributes, path: [params[:name], key]
            end
          end if params[:properties]

        end if @serializer.attributes.any?
      end

      def validate_href
        href = @serializer.href
        case href
        when String
          error_for :url, root: :href if url_is_invalid? href
        when Hash
          href.each do |key, value|
            error_for :url, root: :href, path: [key] if url_is_invalid? value
          end
        end
      end

      def validate_links
        @serializer.links.first.each do |k, link|
          unless link.key? :href
            error_for :missing_attribute, root: :links, path: [k, :href]

            next
          end

          link.each do |key, value|
            case key
            when :href
              if url_is_invalid? link[:href]
                error_for :url, root: :links, path: [k, key]
              end
            else
              if value_is_invalid? value
                error_for :value, root: :links, path: [k, key]
              end
            end
          end
        end if @serializer.links.present?
      end

      def validate_template
        @serializer.template.each do |attr|
          params = attr.extract_params

          params[:properties].each do |key, value|
            if value_is_invalid? value
              error_for :value, root: :template, path: [params[:name], key]
            end
          end if params[:properties]

        end if @serializer.template.any?
      end

      def value_is_invalid?(value)
        v = CollectionJson::Serializer::Validator::Value.new(value)
        v.invalid?
      end

      def url_is_invalid?(value)
        v = CollectionJson::Serializer::Validator::Url.new(value)
        v.invalid?
      end

      def error_for(kind, root:, path: [])
        case kind.to_sym
        when :url
          ending = " is an invalid URL"
        when :value
          ending = " is an invalid value"
        when :missing_attribute
          ending = " is missing"
        else
          ending = " is an invalid value"
        end

        @errors[root] = [] unless @errors.key? root
        e = "#{@serializer.class} #{root}"
        e << ":" + path.join(":") if path.any?
        e << ending
        @errors[root] << e
      end
    end
  end
end