$(function () {
// Backbone models

    User = Backbone.Model.extend({
        url: '/user/'

    });

    Household = Backbone.Collection.extend({
        model: User,
        initialize: function (household_id) {
            this.url = '/household/'+household_id+'/users';
            this.id = household_id;
        },
        grab: function (cb, test) {
            if (test) {
                for (var i = 0; i < 10; i++) {
                    this.add(getUserStub(i));
                }
                cb();
            } else {
                this.fetch({
                    success: function () {
                        cb();
                    }
                });
            }
        },
        parse: function (response) {
            return response;
        },
        getUserByObjectId: function (objectId) {
            var filteredLyst = this.models.filter(function (user) {
                return (objectId == user.get('objectId'));
            });
            return (filteredLyst.length === 0) ? undefined : filteredLyst[0];
        }
    });

    Task = Backbone.Model.extend({
        url: '/task/',
        initialize: function () {
            var taskModel = this;
            var objectId = this.get('objectId') ? this.get('objectId') : "";
            this.url = '/task/'+objectId;
            this.on('change', function (attr) {
                var objectId = this.get('objectId') ? this.get('objectId') : "";
                this.url = '/task/'+objectId;
            });
        },
        complete: function (cb) {
            this.set('status', 1);
            this.save({
                success: cb
            });
        }
    });

    Payment = Backbone.Model.extend({
        url: '/payment/'
    });

    PaymentCollection = Backbone.Collection.extend({
    });

    TaskCollection = Backbone.Collection.extend({
        model: Task,
        initialize: function() {
            this.url = '/household/'+appVars.household.id+'/tasks';
        },
        grab: function (cb, test) {
            if (test) {
                for (var i = 0; i < 10; i++) {
                    this.add(getTaskStub(i));
                }
                cb();
            } else {
                this.fetch({
                    success: function () {
                        cb();
                    }
                });
            }
        },
        getTaskCollectionAsArray: function () {
            var returnArray = [];
            if (this.models.length === 0) {
                return [];
            }
            var headerRow = [];
            for (var i in this.models[0].attributes) {
                headerRow.push(i);
            }
            returnArray.push(headerRow);



            for (i = 0; i < this.models.length; i++) {
                var row = [];
                for (var j = 0; j < headerRow.length; j++) {
                    if (headerRow[j] == "assignee_id") {
                        var assignee_id = this.models[i].get(headerRow[j]);
                        var user = appVars.household.getUserByObjectId(assignee_id);
                        var name = user ? user.get('username') : undefined;
                        row.push(name);
                    } else {
                        row.push(this.models[i].get(headerRow[j]));
                    }
                }
                returnArray.push(row);
            }

            return returnArray;

        }
    });
});

function getTaskStub(i) {
    var newTask = new Task();
    newTask.id = i;
    newTask.set('id', i);
    newTask.set('household_id', 1);
    newTask.set('description', 'haha');
    newTask.set('title', 'title!');
    newTask.set('assignee_id', 1);
    newTask.set('status', 'S');

    return newTask;
}

function getUserStub(i) {
    var newUser = new User();
    newUser.id = i;
    newUser.set('id', i);
    newUser.set('email', 'lol@lol.com');
    newUser.set('password', 'qwerty');
    newUser.set('household_id', 1);
    return newUser;
}

function longpoll() {
    $.get('/longpoll', function (res) {
        console.log(res);
    }, function (err) {
        longpoll();
    });
}
