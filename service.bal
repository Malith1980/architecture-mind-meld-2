import ballerinax/github;
import ballerina/http;

type  Repo record {
    int stars;
    string reponame;
};

github:Client githubEp = check new (config = {
    auth: {
        token: "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"
    }
});

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + name - the input string name
    # + return - string name with hello message or error

    resource function get reposistories(string name) returns Repo[]| error {
           stream<github:Repository, github:Error?> repositories = check githubEp->getRepositories();
            Repo [] | error? repos = from var item in repositories
                where item is github:Repository
                order by item.stargazerCount
                limit 5
                select {
                    reponame: item.name,
                    stars: item.stargazerCount?:0
                };
            return repos?:[];
    }
}
