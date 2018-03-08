let project = new Project('MampfMonster');
project.addSources('Sources');
project.addShaders('Sources/Shaders/**');
project.addAssets('Assets/**');
resolve(project);
