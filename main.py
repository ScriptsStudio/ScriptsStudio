import git


class Feature:
    def __init__(self, name, permission, path):
        self.name = name
        self.permission = permission
        self.path = path
        self.installation_bit = 0

    def install(self):
        return

    def __str__(self):
        return "name: " + self.name + " permission: " + str(self.permission) + " path: " + self.path

    def activate_feature(self):
        self.installation_bit = 1

    def deactivate_feature(self):
        self.installation_bit = 0


class VenvFeature(Feature):
    def __init__(self, name, permission, path, pip_installs):
        super().__init__(name, permission, path)
        self.pip_installs = pip_installs

    def __str__(self):
        return super().__str__() + " pip installs: " + self.pip_installs

    def install(self):
        super().install()
        # Python venv

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
        self.features = {}
        self.features["holaa"] = VenvFeature("holaa", "0", "/home/axel/Escritorio/.customizer/bin/holaa", ["pgadmin_data", "pgadmin4"])
        self.features["Daviid"] = GitFeature("Daviid", "1", "/home/axel/Escritorio/git/gitlab/asix2atesting", "https://gitlab.com/Axlfc/Asix2Atesting")

    def __str__(self):
        d = ""
        for feature in self.features.values():
            d += feature.__str__() + "\n"
        return d

    def install_all(self):
        for feature in self.features.values():
            feature.install()
        return

    def add_feature(self, feature_key):
        self.features[feature_key].activate_feature()


    def execute(self):
        for feature in self.features.values():
            if feature.installation_bit == 1:
                feature.install()
        return


if __name__ == "__main__":
    c = Customizer()
    c.install_all()
    print(c)
