window.addEventListener('message', function(event) {
    const data = event.data;
    if (data.type === 'updateEntry') {
        document.getElementById('rank' + data.index).textContent = data.rank;
        document.getElementById('length' + data.index).textContent = data.length;
        document.getElementById('angler' + data.index).textContent = data.name;
        document.getElementById('caught' + data.index).textContent = data.time;

        const container = document.querySelector('.leaderboard-container' + data.index);
        if (container) {
            container.style.display = 'flex';
        }
    } else if (data.type === 'toggleLeaderboard') {
        toggleLeaderboard();
    }
});

function toggleLeaderboard() {
    const leaderboard = document.querySelector('.card');
    leaderboard.style.display = 'flex';
}

document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        // Send the POST request to close the fishing interface
        $.post(`https://jomidar-fishing/close`, JSON.stringify({ }), function (x) {});
        
        // Hide all elements with the class 'card'
        document.querySelectorAll('.card').forEach(function(card) {
            card.style.display = 'none';
        });
    }
});
