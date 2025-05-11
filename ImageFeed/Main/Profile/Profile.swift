struct Profile {
    let username: String
    let name: String
    let bio: String
    
    var loginName: String { "@\(username)" }
    
    init(username: String, name: String, bio: String) {
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
    init(from responseBody: ProfileResponseBody) {
        username = responseBody.username
        name = responseBody.firstName + " " + (responseBody.lastName ?? "")
        bio = responseBody.bio ?? ""
    }
}
