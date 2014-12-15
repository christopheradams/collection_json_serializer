require "minitest_helper"

module CollectionJson
  class Serializer
    class Objects
      class Item
        class TestItem < Minitest::Test
          def setup
            @user1 = User.new(name: "Carles Jove", email: "hola@carlus.cat")
            @user2 = User.new(name: "Aina Jove", email: "hola@example.com")
            @user_serializer = UserSerializer.new(@user1)
            @item = Item.new(@user_serializer)
          end

          def test_that_an_item_can_be_build
            expected = {
              href: "http://example.com/users/#{@user1.id}",
              data: [
                { name: "name", value: "Carles Jove" },
                { name: "email", value: "hola@carlus.cat" }
              ],
              links: [
                { name: "dashboard", href: "http://example.com/my-dashboard" }
              ]
            }

            assert_equal expected.to_json, @item.create.to_json
          end

          def test_that_an_item_can_be_built_passing_an_index
            user_serializer = UserSerializer.new([@user1, @user2])
            item = Item.new(user_serializer, item: 1)

            expected = {
              href: "http://example.com/users/#{@user2.id}",
              data: [
                { name: "name", value: "Aina Jove" },
                { name: "email", value: "hola@example.com" }
              ],
              links: [
                { name: "dashboard", href: "http://example.com/my-dashboard" }
              ]
            }

            assert_equal expected.to_json, item.create.to_json
          end

          def test_that_an_item_can_be_build_with_random_attributes
            custom_serializer = CustomItemSerializer.new(@user1)
            item = Item.new(custom_serializer)

            expected = {
              data: [
                { name: "name", value: "Carles Jove", anything: "at all", whatever: "really" },
              ]
            }
            assert_equal expected.to_json, item.create.to_json
          end

          def test_that_an_item_link_can_be_build_with_unlimited_attributes
            custom_serializer = CustomItemLinksSerializer.new(@user1)
            item = Item.new(custom_serializer)

            expected = {
              links: [
                { name: "dashboard", href: "/my-dashboard", anything: "at all", whatever: "really" }
              ]
            }

            assert_equal expected[:links], item.create[:links]
          end

          def test_that_unknown_attributes_are_silently_ignored
            serializer_with_unknown_attr = UnknownAttributeSerializer.new(@user1)
            item = Item.new(serializer_with_unknown_attr)
            refute item.create.include?(:unknown)
          end
        end
      end
    end
  end
end
