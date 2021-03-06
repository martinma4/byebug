module Byebug
  #
  # Tests enabling breakpoints.
  #
  class EnableTestCase < TestCase
    def program
      strip_line_numbers <<-EOC
         1:  module Byebug
         2:    #
         3:    # Toy class to test breakpoints
         4:    #
         5:    class #{example_class}
         6:      def self.a(num)
         7:        num + 1
         8:      end
         9:
        10:      def b
        11:        3
        12:      end
        13:    end
        14:
        15:    y = 3
        16:
        17:    byebug
        18:
        19:    z = 5
        20:
        21:    #{example_class}.new.b
        22:    #{example_class}.a(y + z)
        23:  end
      EOC
    end

    def test_enable_breakpoints_with_short_syntax_sets_enabled_to_true
      enter 'b 21', 'b 22', 'disable breakpoints',
            -> { "enable b #{Breakpoint.first.id}" }

      debug_code(program) { assert_equal true, Breakpoint.first.enabled? }
    end

    def test_enable_breakpoints_with_short_syntax_stops_at_enabled_breakpoint
      enter 'break 21', 'break 22', 'disable breakpoints',
            -> { "enable b #{Breakpoint.first.id}" }, 'cont'

      debug_code(program) { assert_equal 21, state.line }
    end

    def test_enable_all_breakpoints_sets_all_enabled_flags_to_true
      enter 'break 21', 'break 22', 'disable breakpoints', 'enable breakpoints'

      debug_code(program) do
        assert_equal true, Breakpoint.first.enabled?
        assert_equal true, Breakpoint.last.enabled?
      end
    end

    def test_enable_all_breakpoints_stops_at_first_breakpoint
      enter 'b 21', 'b 22', 'disable breakpoints', 'enable breakpoints', 'cont'

      debug_code(program) { assert_equal 21, state.line }
    end

    def test_enable_all_breakpoints_stops_at_last_breakpoint
      enter 'break 21', 'break 22', 'disable breakpoints',
            'enable breakpoints', 'cont', 'cont'

      debug_code(program) { assert_equal 22, state.line }
    end

    def test_enable_breakpoints_with_full_syntax_sets_enabled_to_false
      enter 'break 21', 'break 22', 'disable breakpoints',
            -> { "enable breakpoints #{Breakpoint.last.id}" }

      debug_code(program) { assert_equal false, Breakpoint.first.enabled? }
    end

    def test_enable_breakpoints_with_full_syntax_stops_at_enabled_breakpoint
      enter 'break 21', 'break 22', 'disable breakpoints',
            -> { "enable breakpoints #{Breakpoint.last.id}" }, 'cont'

      debug_code(program) { assert_equal 22, state.line }
    end

    def test_enable_by_itself_shows_help
      enter 'enable'
      debug_code(program)

      check_output_includes(/Enables breakpoints or displays./)
    end
  end
end
