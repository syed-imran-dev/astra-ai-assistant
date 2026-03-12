require('dotenv').config();
const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const cors = require('cors');
const aiService = require('./services/aiService');

// 1. Initialize Express and HTTP Server
const app = express();
const server = http.createServer(app);

// 2. Configure Socket.io for Real-time 3D Synchronization
const io = new Server(server, {
    cors: {
        origin: "*", // In production, restrict this to your app's domain
        methods: ["GET", "POST"]
    }
});

// 3. Middleware
app.use(cors());
app.use(express.json());

// 4. REST API: The Math Solver Engine
app.post('/api/v1/solve', async (req, res) => {
    const { problem, userId } = req.body;

    if (!problem) {
        return res.status(400).json({ error: "No math problem provided." });
    }

    console.log(`[Axiom Engine] Solving for User ${userId || 'Guest'}: ${problem}`);

    try {
        // Calls the AI Service to get both Text (LaTeX) and 3D (JSON)
        const solution = await aiService.solveMathProblem(problem);

        // Broadcast the 3D data to Unity immediately via Sockets
        io.emit('spatial-update', solution.spatial_data);

        // Return the full payload to the Mobile App
        res.status(200).json({
            success: true,
            timestamp: new Date().toISOString(),
            payload: solution
        });

    } catch (error) {
        console.error("Axiom Solve Error:", error.message);
        res.status(500).json({ 
            success: false, 
            error: "The AI engine could not solve this problem. Please check your query." 
        });
    }
});

// 5. Health Check (Standard for Senior-level Cloud Deployments)
app.get('/api/v1/health', (req, res) => {
    res.status(200).json({ 
        status: "Online", 
        engine: "Axiom-Spatial-v1",
        uptime: process.uptime() 
    });
});

// 6. Socket.io Event Handling
io.on('connection', (socket) => {
    console.log(`[Socket] Client Synced: ${socket.id}`);

    // Listen for manual 3D manipulations from the Mobile "Inspector"
    socket.on('manual-transform', (data) => {
        console.log("Manual override received for Unity:", data);
        socket.broadcast.emit('spatial-update', data);
    });

    socket.on('disconnect', () => {
        console.log(`[Socket] Client Unsynced: ${socket.id}`);
    });
});

// 7. Start Server
const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
   
    console.log(`System Ready!!!`);
});
