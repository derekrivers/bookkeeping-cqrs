module Domain
  module Business
    module Entities
      class AddressEntity
        attr_reader :id, :line1, :line2, :city, :postcode, :country_code

        def initialize(id:, line1:, city:, postcode:, country_code:, line2: nil)
          @id = id
          @line1 = line1
          @line2 = line2
          @city = city
          @postcode = postcode
          @country_code = country_code
        end

        def update(line1:, city:, postcode:, country_code:, line2: nil)
          @line1 = line1
          @line2 = line2
          @city = city
          @postcode = postcode
          @country_code = country_code
        end

        def to_h
          {
            id: id,
            line1: line1,
            line2: line2,
            city: city,
            postcode: postcode,
            country_code: country_code
          }
        end

        def self.from_h(hash)
          new(
            id: hash[:id],
            line1: hash[:line1],
            line2: hash[:line2],
            city: hash[:city],
            postcode: hash[:postcode],
            country_code: hash[:country_code]
          )
        end
      end
    end
  end
end
