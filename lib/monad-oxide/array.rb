# Reopen Array to add some handy capabilities idoimatic to Ruby.
class Array

  ##
  # Converts an Array into a single Result.  Returns Ok containing all values
  # if every element succeeds, otherwise returns Err containing _any_ errors.
  #
  # Element interpretation:
  # - Ok/Err Results: evaluated for success/failure.
  # - Exceptions: treated as errors.
  # - Other values: treated as successes.
  #
  # @return [MonadOxide::Result<Array<V>, Array<E>>] Ok with all values if
  #   all succeed, or Err with all errors if any fail.
  def into_result()
    tracker = {
      oks: [],
      errs: [],
    }
    self.each do |element|
      (
        element.is_a?(MonadOxide::Result) ?
          element :
          (element.is_a?(Exception) ?
            MonadOxide.err(element) :
            MonadOxide.ok(element)
            )
      )
        .match({
          MonadOxide::Ok => ->(x) { tracker[:oks].push(x) },
          MonadOxide::Err => ->(e) { tracker[:errs].push(e) },
        })
    end
    tracker[:errs].empty?() ?
      MonadOxide.ok(tracker[:oks]) :
      MonadOxide.err(tracker[:errs])
  end

end
