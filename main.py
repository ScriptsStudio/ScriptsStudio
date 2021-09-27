import git


class Feature:
    def __init__(self, name, permission, path):
        self.name = name
        self.permission = permission
        self.path = path

    def install(self):
        return

    def __str__(self):
        return "name: " + self.name + " permission: " + str(self.permission) + " path: " + self.path


class GitFeature(Feature):
    def __init__(self, name, permission, path, url):
        super().__init__(name, permission, path)
        self.url = url

    def install(self):
        super().install()
        git.repo.base.Repo.clone_from(self.url, self.path)

    def __str__(self):
        return super().__str__() + " url: " + self.url


class Customizer:
    def __init__(self):
        self.features = []
        self.features.append(Feature("holaa", "0", "/home/axel/Escritorio/.customizer/bin/holaa"))
        self.features.append(GitFeature("Daviid", "1", "/home/axel/Escritorio/.customizer/bin/asix2atesting", "https://gitlab.com/Axlfc/Asix2Atesting"))

    def __str__(self):
        d = ""
        for feature in self.features:
            d += feature.__str__() + "\n"
        return d

    def install_all(self):
        for feature in self.features:
            feature.install()
        return

if __name__ == "__main__":
    c = Customizer()
    c.install_all()
    print(c)
