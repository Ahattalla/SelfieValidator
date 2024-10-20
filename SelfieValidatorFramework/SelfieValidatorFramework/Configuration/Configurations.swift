public enum Configurations {
    public private(set) static var delegate: SelfieValidatorDelegate?
}

public extension Configurations {
    func setup(delegate: SelfieValidatorDelegate) {
        Configurations.delegate = delegate
    }
}

