
$(function () {
    TaskView = Backbone.View.extend({
        model: Task,
        initialize: function () {
            if (this.model instanceof Task) {
                var tableRow = $('<tr>');

                var attributes = ['description', 'title', 'assignee_id', 'status'];

                var descriptionEntry = $('<td>');
                descriptionEntry.html(this.model.get('description'));
                var titleEntry = $('<td>');
                titleEntry.html(this.model.get('title'));
                var assignee_id = $('<td>');
                assigneeEntry.html(app.household.get(this.model.get('assignee_id')));
                var status = $('<td>');
                status.html(this.model.get('status'));
            }
        }
    });

    TaskCollectionView = Backbone.View.extend({
        collection: TaskCollection,
        initalize: function () {

            var taskViews = {};

            var thisCollectionView = this;

            var addView = function (model) {
                var newTaskView = new TaskView({
                    'model': model
                });

                taskViews[model.id] = newTaskView;
                thisCollectionView.$el.append(newTaskView);
            };

            this.collection.on('add', addView);

            this.collection.on('remove', function (model) {
                taskViews[model.id].remove();
            });

            this.collection.on('reset', function (model, collection) {
                for (var i in taskViews) {
                    taskViews[i].remove();
                }
                for (var j = 0; j < collection.models.length; j++) {
                    var collectionModel = collection.models[j];
                    addView(collectionModel);
                }
            });

            // Initialize this DOM element

            var $table = $('<table>');
            var $tableRow = $('<tr>');
            $table.append($tableRow);

            var headers = ["Description", "Title", "Assignee", "Status"];

            for (var i = 0; i < headers.length; i++) {
                $tableRow.append($('<td>'+headers[i]+'</td>'));
            }

            this.setElement($table);
        }
    });
});

