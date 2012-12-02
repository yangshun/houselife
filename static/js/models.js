$(function () {
// Backbone models

    User = Backbone.Model.extend({
        url: '/user/'

    });

    Household = Backbone.Collection.extend({
        model: User,
        initialize: function () {
            this.url = 'user/'+user.id+'/household';
        }
    });

    Task = Backbone.Model.extend({
        url: '/task/'
    });

    Payment = Backbone.Model.extend({
        url: '/payment/'
    });

    PaymentCollection = Backbone.Collection.extend({
    });

    TaskCollection = Backbone.Collection.extend({
        model: Task,
        initialize: function() {
            this.url = '/user/'+user.id+'/tasks';
        }
    });
});
