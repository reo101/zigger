const std = @import("std");
const orca = @cImport({
    @cInclude("discord.h");
});

fn on_ready(client: ?*orca.discord) callconv(.C) void {
    const bot: *const orca.discord_user = orca.discord_get_self(client);
    // orca.log_info("Logged in as %s!", bot.*.username);

    // std.io.getStdOut().writeAll(
    //     @as([]const u8, bot.*.username),
    // ) catch unreachable;

    _ = bot;
}

fn on_message(client: ?*orca.discord, msg: ?*const orca.discord_message) callconv(.C) void {
    std.io.getStdOut().writeAll("Recieved command\n") catch unreachable;

    if (std.zig.c_builtins.__builtin_strcmp(msg.?.*.content, "ping") != 0) {
        return; // ignore messages that aren't 'ping'
    }

    // orca.discord_async_next(client, null); // make next request non-blocking (OPTIONAL)

    var content = "pong";

    var params = orca.discord_create_message_params{
        .content = @ptrCast([*c]u8, &content),
        .tts = false,
        .embeds = null,
        .embed = null,
        .allowed_mentions = null,
        .message_reference = null,
        .components = null,
        .sticker_ids = null,
        .attachments = null,
    };

    _ = orca.discord_create_message(client.?, msg.?.*.channel_id, &params, null);
}

pub fn main() anyerror!void {
    const BOT_TOKEN = "BAITED";

    var client: ?*orca.discord = @ptrCast(?*orca.discord, orca.discord_init(BOT_TOKEN));
    orca.discord_set_on_ready(client, on_ready);
    orca.discord_set_on_message_create(client, on_message);
    _ = orca.discord_run(client);

    _ = orca.discord_cleanup(client);
}
