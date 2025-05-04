struct Profile {
    let username: String
    let name: String
    var loginName: String { "@\(username)" }
    let bio: String
    
    init (username: String, name: String, bio: String) {
        self.username = username
        self.name = name
        self.bio = bio
    }
    
    init() {
        username = "username"
        name = "Name"
        bio = "Bio."
    }
}

extension Profile {
    static func get(from responseBody: ProfileResponseBody) -> Profile {
        return Profile(
            username: responseBody.username,
            name: responseBody.firstName + " " + (responseBody.lastName ?? ""),
            bio: responseBody.bio ?? ""
        )
    }
}
