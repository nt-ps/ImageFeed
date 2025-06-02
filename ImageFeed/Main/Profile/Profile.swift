public struct Profile {
    let username: String
    let name: String
    let bio: String
    
    var loginName: String { "@\(username)" }
    
    init(
        username: String = "username",
        name: String = "Name",
        bio: String = "Bio."
    ) {
        self.username = username
        self.name = name
        self.bio = bio
    }
}

extension Profile {
    init(from responseBody: ProfileResponseBody) {
        username = responseBody.username
        name = responseBody.firstName + " " + (responseBody.lastName ?? "")
        bio = responseBody.bio ?? ""
    }
}
