$(function () {
// Backbone models

    User = Backbone.Model.extend({
        url: '/user/'

    });

    Household = Backbone.Collection.extend({
        model: User,
        initialize: function (household_id) {
            this.url = 'household/'+household_id+'/users';
            this.id = household_id;
        },
        grab: function (cb, test) {
            if (test) {
                for (var i = 0; i < 10; i++) {
                    this.add(getUserStub(i));
                }
                cb();
            } else {
                this.fetch();
            }
        }
    });

    Task = Backbone.Model.extend({
        url: '/task/',
        initialize: function () {
            var taskModel = this;
            this.url = '/task/'+this.get('objectId');
            this.on('change', function (attr) {
                this.url = '/task/'+this.get('objectId');
                if (!attr.status) {
                    taskModel.set('status', 0);
                }
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
