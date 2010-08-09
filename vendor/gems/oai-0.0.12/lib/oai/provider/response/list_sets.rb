module OAI::Provider::Response

  class ListSets < Base

    def to_xml
      raise OAI::SetException.new unless provider.model.sets && !provider.model.sets.nil? && !provider.model.sets.empty?

      response do |r|
        r.ListSets do
          provider.model.sets.each do |set|
            r.set do
              r.setSpec set.spec
              r.setName set.name
              r.setDescription(set.description) if set.respond_to?(:description)
            end
          end
        end
      end
    end

  end

end
