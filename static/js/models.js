$(function () {
// Backbone models

    User = Backbone.Model.extend({
        url: '/user/'

    });

    Household = Backbone.Collection.extend({
        model: User,
        initialize: function () {
            this.url = 'household/'+this.household_id+'users';
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
            this.url = '/task/'+this.id;
            this.on('change', function () {
                this.url = '/task/'+this.id;
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
            this.url = '/household/'+appVars.household.get('id')+'/tasks';
        },
        grab: function (cb, test) {
            if (test) {
                for (var i = 0; i < 10; i++) {
                    this.add(getTaskStub(i));
                }
                cb();
            } else {
                this.fetch();
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
