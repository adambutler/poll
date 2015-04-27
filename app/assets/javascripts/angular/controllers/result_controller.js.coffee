angular
  .module("Poll")
  .controller "ResultController", ["$scope", "$interval", "Pusher", ($scope, $interval, Pusher) ->

      $scope.ctx = $('canvas')[0].getContext("2d")

      $scope.chartData = []
      $scope.chartOptions = {
        responsive: true
        showTooltips: false
        animationSteps: 45
      }

      $scope.updateChart = ->
        $.ajax
          url: "/#{$scope.question}/results.json"
          success: (data) ->
            $scope.$apply ->
              if $scope.chartData.length != data.length
                colors = color.randomColors(data.length)
                $scope.chartData = $.extend true, data, colors
              else
                $scope.chartData = $.extend true, $scope.chartData, data

              total = 0
              for datum, index in data
                total += datum.value

              console.log "Total = #{total}"

              if $scope.chart?
                console.log 'a'
                for datum, index in data
                  $scope.chart.segments[index].value = datum.value
                $scope.chart.update()
              else if total > 0
                console.log 'b'
                $scope.chart = new Chart($scope.ctx).Doughnut($scope.chartData, $scope.chartOptions)


      $scope.setQuestion = (question) ->
        $scope.question = question
        $scope.updateChart()
        channel = Pusher.subscribe(question)
        channel.bind "vote", ->
          $scope.updateChart()

  ]
