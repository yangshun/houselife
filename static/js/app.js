function renderGraph(el) {
    var taskData = taskCollection.getTaskCollectionAsArray();

    var headers = taskData[0];

    var userIndex = headers.indexOf('assignee_id');


    var filteredData = [];
    for (var i = 0; i < taskData.length; i++) {
        filteredData.push(taskData[i].filter(function (el, index) {
            return (index == userIndex);
        })[0]);
    }

    var dictCount = {};


    for (var j = 1; j < filteredData.length; j++) {
        if (dictCount[filteredData[j]]) {
            dictCount[filteredData[j]]++;
        } else {
            dictCount[filteredData[j]] = 1;
        }
    }


    var dataTable = [];
    dataTable.push(['User', 'Tasks Done']);
    for (var k in dictCount) {
        dataTable.push([k,dictCount[k]]);
    }


    var data = google.visualization.arrayToDataTable(dataTable);

    var options = {
      title: 'Task Distribution',
      backgroundColor: undefined
    };
    var chart = new google.visualization.PieChart(el);
    chart.draw(data, options);
    $($('rect')[0]).attr('fill','none');
    taskCollection.off('reset', renderGraph);
}


function renderTime(thisView) {
/*    if (user.objectId) {
        var user = new User(user.objectId);
    }
    var myTasks = taskCollection.models.filter(function (task) {
        //return (task.get('assignee_id') == user.get('objectId'));
    });

    times = [];
    for (var i = 0; i < myTasks.length; i++) {
        times.push(new Date(myTasks.get('updated_at')));
    }

    console.log(times);
*/
}

$(function () {

    appVars = {};

    var App = Backbone.Router.extend({
        initialize: function () {

            var views = this.views = {
                'todo': new TodoView(),
                'feed': new FeedView(),
                'analytics': new AnalyticsView(),
                'expenses': new ExpensesView()
            };

            var hideViews = this.hideViews = function () {
                for (var i in views) {
                    views[i].hide();
                }
            };

            var thisApp = this;

            $('#nav-todo').click(function (e) {
                e.preventDefault();
                thisApp.navigate('dashboard/todo', {trigger:true});
            });

            $('#nav-analytics').click(function (e) {
                e.preventDefault();
                thisApp.navigate('dashboard/analytics', {trigger:true});
                renderGraph(views['analytics'].$el.find('#distribution-graph')[0]);
            });

            $('#nav-expenses').click(function(e) {
                e.preventDefault();
                thisApp.navigate('dashboard/expenses', {trigger:true});
            });

            $('#nav-logout').click(function (e) {
                e.preventDefault();
                window.location.href = '/logout';
            });

            this.route(/^dashboard\/(.*)/, "default", function () {
                this.showView('todo');
            });
            this.route(/^dashboard\/(.*)/, "view", this.showView);




        },
        showView: function(view) {
            this.hideViews();
            this.views[view].show();
        }
    });

    var NavigationView = Backbone.View.extend({
        hide: function () {
            this.$el.hide();
        },
        show: function () {
            this.$el.show();
        }
    });


    var TodoView = NavigationView.extend({
        el: $('#todo-container'),
        initialize: function () {
            taskCollection = new TaskCollection();
            taskCollectionView = new TaskCollectionView({
                collection: taskCollection
            });

            completedTaskCollectionView = new CompletedTaskCollectionView({
                collection: taskCollection
            });

            deletedTaskCollectionView = new DeletedTaskCollectionView({
                collection: taskCollection
            });

            taskCollection.grab(function () {
                $('#add-task-btn').click(function () {
                    $( "#dialog-modal" ).dialog({
                        height: 370,
                        width: 750,
                        modal: true
                    });
                });
            }, false);
            $('#tasks-container').append(taskCollectionView.$el);
            $('#completed-tasks-container').append(completedTaskCollectionView.$el);
            $('#deleted-tasks-container').append(deletedTaskCollectionView.$el);



        }

    });

    var FeedView = NavigationView.extend({
        el: $('#feed-container'),
        initialize: function() {

        }
    });

    var AnalyticsView = NavigationView.extend({
        el: $('#analytics-container'),
        initialize: function () {
            var thisView = this;

            if (google.visualization) {
                drawChart();
            } else {
                google.setOnLoadCallback(drawChart);
            }
            function drawChart() {
                if (taskCollection.length === 0) {
                    taskCollection.on('reset', function () {
                        renderGraph(thisView.$el.find('#distribution-graph')[0]);
                        renderTime(thisView);
                    });
                } else {
                    renderGraph(this.el);
                    renderTime(thisView);
                }
            }
        }
    });

    var ExpensesView = NavigationView.extend({
        el: $('#expenses-container'),
        initialize: function () {

        }
    });

    appVars.user = new User(user);
    appVars.household = new Household(appVars.user.get('household_id'));
    appVars.household.grab(function () {
        app = new App({});
        Backbone.history.start({pushState:true});

        new ModalEditView();

    }, false);

    appVars.user = new User();
    appVars.user.set(user);

    



});