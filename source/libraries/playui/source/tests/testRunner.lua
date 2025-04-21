-- See: https://martin-fieber.de/blog/how-to-test-your-lua/#unit-testing-via-assert

-- Runner: A simple test runner utility for executing test functions
-- and reporting any errors that occur during testing.
local Runner = {
    hasErrors = false -- Tracks whether any tests have failed
}

-- Executes a test function and catches any errors
-- @param fn - The test function to execute
function Runner:test(fn)
    -- Use pcall to safely execute the test function
    local status, err = pcall(fn)

    -- If the test function threw an error
    if not status then
        self.hasErrors = true -- Mark that we encountered an error
        print(err)            -- Output the error message
    end
end

-- Evaluates the results of all tests and exits with appropriate status code
function Runner:evaluate()
    if self.hasErrors then
        print("Test suite exited with errors")
        os.exit(1) -- Exit with error code 1 if any tests failed
    else
        print("All tests successful")
        -- Implicit exit with code 0 (success)
    end
end

-- Return the Runner module
return Runner
