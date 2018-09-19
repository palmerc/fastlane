module Fastlane
  module Actions
    class ListKeychainsAction < Action
      def self.run(params)
        add_to_search_list = params[:add_to_search_list]
        search_list = params[:search_list]
        domain = params[:domain]

        command = "security list-keychains"
        if domain == :user || domain == :system || domain == :common || domain == :dynamic
          domain_name = domain_type_name(domain)
          command << " -d #{domain_name}"
        end

        if add_to_search_list == true || add_to_search_list == :add
          keychains = Fastlane::Actions.sh(command, log: false).shellsplit
        end

        if not search_list.nil?
          for search_element in search_list
            unless keychains.include?(search_element)
              keychains << search_element
            end
          end

          command << " -s #{keychains.shelljoin}"
        end

        Fastlane::Actions.sh(command, log: false)
      end

      def domain_type_name(domain)
          return "user" if domain == :user
          return "system" if domain == :system
          return "common" if domain == :common
          return "dynamic" if domain == :dynamic
          return "Unknown"
      end

      def self.details
        "The keychain search list can be retrieved and set directly"
      end

      def self.description
        "List keychains and set the search list"
      end

      def self.available_options
        FastlaneCore::ConfigItem.new(key: :add_to_search_list,
                                     description: 'Add keychain items to search list',
                                     is_string: false,
                                     optional: true)
        FastlaneCore::ConfigItem.new(key: :search_list,
                                     description: 'List of items to add to the search list',
                                     optional: true)
        FastlaneCore::ConfigItem.new(key: :domain,
                                     description: 'Restrict command to a specific domain',
                                     is_string: false,
                                     optional: true)
      end

      def self.authors
        ["palmerc"]
      end

      def self.example_code
        [
            'list_keychains( # Unlock an existing keychain and add it to the keychain search list
          )',
            'list_keychains( # Limit to a specific domain (:user, :system, :common, or :dynamic)
            domain: :user
          )',
            'list_keychains( add_to_search_list: :replace # To only add a keychain use `true` or `:add`.
          )'
        ]
      end

      def self.category
        :misc
      end
    end
  end
end