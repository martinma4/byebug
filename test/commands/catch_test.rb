module Byebug
  #
  # Tests exception catching
  #
  class CatchTestCase < TestCase
    def test_catch_removes_specific_catchpoint
      enter 'catch NoMethodError', 'catch NoMethodError off'
      debug_code(minimal_program)

      assert_empty Byebug.catchpoints
    end

    def test_catch_off_removes_all_catchpoints_after_confirmation
      enter 'catch NoMethodError', 'catch off', 'y'
      debug_code(minimal_program)

      assert_empty Byebug.catchpoints
    end
  end
end
