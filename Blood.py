import discord
from discord.ext import commands
import re
import random
import asyncio
import os
import aiofiles
import io
from github import Github
import base64
import datetime
import aiohttp
import requests
from bs4 import BeautifulSoup

file_path = 'accounts.txt'
permission_mode = 0o666
VERIFICATION_ROLE_ID = 1223469040278962287

GITHUB_TOKEN = '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'
REPO_OWNER = 'RedDaGoodScripter12355939292'
REPO_NAME = 'HACKAZZ'
FILE_PATH = 'Authorization.lua'
COOLDOWN_TIME = 2 * 60 * 60

g = Github(GITHUB_TOKEN)
repo = g.get_repo(f"{REPO_OWNER}/{REPO_NAME}")

try:
    # Change the file permissions
    os.chmod(file_path, permission_mode)
    print(f"Permissions for '{file_path}' have been set to {oct(permission_mode)}")
except FileNotFoundError:
    print(f"The file '{file_path}' was not found.")
except Exception as e:
    print(f"An error occurred while setting permissions: {e}")

DISCORD_TOKEN = 'MTEyOTk5NjU0NDkyNjU1NjI1MA.G4wmW-.2TcDfVvFRNNQVYb_uED6BiDuHhMJFu3aWx_6zI'
FILENAME = 'accounts.txt'

webhook_url = 'https://discord.com/api/webhooks/1223484963102396466/v2rsKO_UPIg9uD2UT4z_F8X2b5niiV3_G1o60VSDVvsh4SiheGI74uu1xu0RUZSF6VMn'

warnings = {}
allowed_channel_ids = [1223480728545660979, 1223482263459860500]

intents = discord.Intents.all()

bot = commands.Bot(command_prefix='!', intents=intents)

@bot.event
async def on_ready():
    print(f'Logged in as {bot.user.name}')
    await set_custom_status()
    await start_verification()

@bot.event
async def on_message(message):
    if message.author == bot.user:
        return

    await bot.process_commands(message)

async def set_custom_status():
    status = discord.Status.dnd
    await bot.change_presence(status=status, activity=discord.Game("FUCKING YALL MOMMIES"))

def create_embed_response(content, color):
    embed = discord.Embed(description=content, color=color)
    return embed

async def send_colored_embed(channel, content, color):
    embed = create_embed_response(content, color)
    await channel.send(embed=embed)

def has_owner_role(ctx):
    allowed_roles = {
        1223468092408205402,
        1505502725603852419
    }

    return any(role.id in allowed_roles for role in ctx.author.roles)

def is_paid_user(ctx):
    paid_role_id = 1223468285476077688
    paid_role = discord.utils.get(ctx.guild.roles, id=paid_role_id)
    return paid_role in ctx.author.roles

async def start_verification():
    guild = bot.get_guild(1223467569663709338)
    channel = guild.get_channel(1223472662542553148)
    
    embed = discord.Embed(title="Verification", description="React with ✅ to get verified!", color=0x00ff00)
    message = await channel.send(embed=embed)
    
    await message.add_reaction("✅")

@bot.event
async def on_reaction_add(reaction, user):
    if user == bot.user:
        return
    if str(reaction.emoji) == "✅":
        guild = bot.get_guild(1223467569663709338)
        role = guild.get_role(VERIFICATION_ROLE_ID)
        await user.add_roles(role)

@bot.command()
@commands.check(has_owner_role)
async def close(ctx):
    if ctx.channel:
        guild = ctx.guild
        role = discord.utils.get(guild.roles, id=1223469040278962287)
        if role:
            permissions = discord.PermissionOverwrite()
            permissions.read_messages = True
            permissions.send_messages = False
            await ctx.channel.set_permissions(role, overwrite=permissions)
            await send_colored_embed(ctx.channel, f"This channel is closed. {role.mention} currently can't send messages.", discord.Color.red())
        else:
            await ctx.send("Role not found.")

@bot.command()
@commands.check(has_owner_role)
async def open(ctx):
    if ctx.channel:
        guild = ctx.guild
        role = discord.utils.get(guild.roles, id=1223469040278962287)
        if role:
            permissions = discord.PermissionOverwrite()
            permissions.read_messages = True
            permissions.send_messages = True
            await ctx.channel.set_permissions(role, overwrite=permissions)
            await send_colored_embed(ctx.channel, f"This channel is open again for {role.mention}.", discord.Color.green())
        else:
            await ctx.send("Role not found.")

@bot.command()
@commands.check(has_owner_role)
async def kick(ctx, member: discord.Member, *, reason: str = "No reason provided"):
    await member.kick(reason=reason)
    await ctx.send(f"{member.mention} has been kicked!")
    await send_webhook_info(webhook_url, ctx, member, "KICKED A NEW MEMBER", reason, discord.Color.red())

@bot.command()
@commands.check(has_owner_role)
async def ban(ctx, member: discord.Member, *, reason: str = "No reason provided"):
    await member.ban(reason=reason)
    await ctx.send(f"{member.mention} has been banned!")
    await send_webhook_info(webhook_url, ctx, member, "BANNED A NEW MEMBER", reason, discord.Color.red())

@bot.command()
@commands.check(has_owner_role)
async def warn(ctx, member: discord.Member, *, reason: str = "No reason provided"):
    if member.id in warnings:
        warnings[member.id] += 1
    else:
        warnings[member.id] = 1

    warnings_left = 3 - warnings.get(member.id, 0)

    if warnings_left <= 0:
        await member.ban(reason=f"Accumulated 3 warnings: {reason}")
        await ctx.send(f"{member.mention} has been banned due to 3 warnings!")
        await send_webhook_info(webhook_url, ctx, member, "BANNED A NEW MEMBER (3 Warnings)", reason, discord.Color.orange())
    else:
        await ctx.send(f"{member.mention} has been warned: {warnings_left} warnings left to be banned")
        await send_webhook_info(webhook_url, ctx, member, "WARNED A NEW MEMBER", reason, discord.Color.orange())

@bot.command()
@commands.check(has_owner_role)
async def timeout(ctx, member: discord.Member, minutes: int, *, reason: str = "No reason provided"):
    try:
        duration = datetime.timedelta(minutes=minutes)

        await member.timeout(duration, reason=reason)

        await send_colored_embed(
            ctx.channel,
            f"{member.mention} has been timed out for {minutes} minute(s).\nReason: {reason}",
            discord.Color.orange()
        )

        await send_webhook_info(
            webhook_url,
            ctx,
            member,
            f"TIMED OUT A MEMBER ({minutes}m)",
            reason,
            discord.Color.orange()
        )

    except Exception as e:
        await send_colored_embed(
            ctx.channel,
            f"Failed to timeout member: {str(e)}",
            discord.Color.red()
        )
        
@bot.command()
@commands.check(has_owner_role)
async def untimeout(ctx, member: discord.Member):
    try:
        await member.timeout(None)

        await send_colored_embed(
            ctx.channel,
            f"{member.mention} has been removed from timeout.",
            discord.Color.green()
        )

    except Exception as e:
        await send_colored_embed(
            ctx.channel,
            f"Failed to remove timeout: {str(e)}",
            discord.Color.red()
        )

async def send_webhook_info(webhook_url, ctx, member, action, reason, color):
    if webhook_url:
        default_gif_url = 'https://media.tenor.com/K9hsRJ0p6QQAAAAC/latinos-kissing.gif'

        embed = discord.Embed(title=action, color=color)
        embed.add_field(name="Username", value=member.display_name, inline=False)
        embed.add_field(name="Reason", value=reason, inline=False)
        embed.add_field(name="Warnings", value=warnings.get(member.id, 0), inline=False)
        embed.add_field(name="DiscordUserID", value=member.id, inline=False)

        async with aiohttp.ClientSession() as session:
            webhook = discord.Webhook.from_url(webhook_url, session=session)
            await webhook.send(embed=embed, username=ctx.author.display_name, avatar_url=default_gif_url)

@bot.command()
@commands.check(has_owner_role)
async def send(ctx, channel: discord.TextChannel, *, message: str):
    await send_colored_embed(channel, message, discord.Color.gold())

@bot.command()
async def show_commands(ctx):
    command_list = "\n".join([f"/{cmd.name} - {cmd.help}" for cmd in bot.commands])
    await send_colored_embed(ctx.channel, f"Here are the available commands:\n{command_list}", discord.Color.green())

@bot.command()
@commands.cooldown(1, 600, commands.BucketType.user)
async def gen(ctx: commands.Context):
    if ctx.channel.id not in allowed_channel_ids:
        await send_colored_embed(ctx, "This command is not allowed in this channel.", discord.Color.red())
        return

    available_accounts = await read_from_file()

    if not available_accounts:
        await send_colored_embed(ctx, "No accounts available at the moment.", discord.Color.red())
        return

    available_accounts = available_accounts.splitlines()
    selected_account = random.choice(available_accounts)
    account_info = selected_account.split(':')
    username = account_info[0]
    password = account_info[1]

    display_name, verified, last_online, creation_date = await get_user_info(username)

    info_message = (
        f"**Display Name:** {display_name}\n"
        f"**Verified:** {'Yes' if verified else 'No'}\n"
        f"**Username:** {username}\n"
        f"**Password:** {password}\n"
        f"**Creation Date:** {creation_date}\n"
        f"**Last Online:** {last_online}"
    )


    available_accounts.remove(selected_account)
    await write_to_file('\n'.join(available_accounts))

    await send_colored_embed(ctx.author, info_message, discord.Color.green())
    await send_colored_embed(ctx, f"{ctx.author.mention} ACCOUNT SENT TO DMS", discord.Color.green())

async def get_user_info(username):
    display_name = "Unknown"
    verified = False
    last_online = "Unknown"
    creation_date = "Unknown"

    # Fetching display name and verification status
    display_name_url = "https://users.roblox.com/v1/usernames/users"
    payload = {
        "usernames": [username],
        "excludeBannedUsers": True
    }
    headers = {
        "Content-Type": "application/json"
    }

    try:
        response = requests.post(display_name_url, json=payload, headers=headers)
        if response.status_code == 200:
            data = response.json()["data"][0]
            display_name = data["displayName"]
            verified = data["hasVerifiedBadge"]
        else:
            print(f"Failed to fetch display name and verification status: {response.status_code}")
    except Exception as e:
        print(f"An error occurred while fetching display name and verification status: {e}")

    # Fetching last online status
    last_online_url = f"https://api.newstargeted.com/roblox/presence/v1/last-online.php?username={username}"
    try:
        response = requests.get(last_online_url)
        if response.status_code == 200:
            last_online_data = response.json()
            last_online = last_online_data.get("lastOnline", "Unknown")
        else:
            print(f"Failed to fetch last online status: {response.status_code}")
    except Exception as e:
        print(f"An error occurred while fetching last online status: {e}")

    # Fetching account creation date
    birthdate_url = f"https://users.roblox.com/v1/birthdate"
    try:
        response = requests.get(birthdate_url)
        if response.status_code == 200:
            birthdate_data = response.json()
            birth_month = birthdate_data.get("birthMonth", 0)
            birth_day = birthdate_data.get("birthDay", 0)
            birth_year = birthdate_data.get("birthYear", 0)
            creation_date = f"{birth_year}-{birth_month}-{birth_day}"
        else:
            print(f"Failed to fetch account creation date: {response.status_code}")
    except Exception as e:
        print(f"An error occurred while fetching account creation date: {e}")

    return display_name, verified, last_online, creation_date

@gen.error
async def gen_error(ctx, error):
    if isinstance(error, commands.CommandOnCooldown):
        embed = discord.Embed(title='Cooldown', description=f'This command is on cooldown. Try again in {error.retry_after:.2f} seconds.', color=discord.Color.red())
        await ctx.send(embed=embed)

def update_lua_script(repo, file_path, new_content):
    file = repo.get_contents(file_path)
    repo.update_file(file.path, "Update authorization script", new_content, file.sha)

@bot.command()
async def stock(ctx: commands.Context):
    if ctx.channel.id not in allowed_channel_ids:
        await send_colored_embed(ctx, "This command is not allowed in this channel.", discord.Color.red())
        return

    unused_keys = await count_unused_keys()
    embed = discord.Embed(title='Stock Count', description=f'Number of unused stock keys: {unused_keys}', color=discord.Color.green())
    await ctx.send(embed=embed)

@bot.command()
@commands.is_owner()
async def available(ctx: commands.Context):
    if ctx.channel.id not in allowed_channel_ids:
        await send_colored_embed(ctx, "This command is not allowed in this channel.", discord.Color.red())
        return

    available_accounts = await read_from_file()

    if not available_accounts:
        await send_colored_embed(ctx, "No accounts available at the moment.", discord.Color.red())
        return

    formatted_accounts = '\n'.join(available_accounts.splitlines())
    text_file = io.BytesIO(formatted_accounts.encode('utf-8'))
    
    await ctx.send(
        "Here is the full list of available accounts:",
        file=discord.File(text_file, filename="accounts.txt")
    )
    
@bot.command()
@commands.check(has_owner_role)
async def reset_cooldown(ctx: commands.Context, user: discord.Member):
    bot.get_command('gen').reset_cooldown(ctx)
    await send_colored_embed(ctx, f"The cooldown for {user.mention} has been reset.", discord.Color.green())

async def get_available_keys():
    try:
        async with aiofiles.open(FILENAME, 'r') as file:
            accounts = await file.read()
            return accounts.strip().split('\n')
    except FileNotFoundError:
        return []
    except Exception as e:
        print(f"An error occurred while reading from the file: {e}")
        return []

async def count_unused_keys():
    try:
        async with aiofiles.open(FILENAME, mode='r') as file:
            existing_lines = await file.read()
            return len(existing_lines.strip().split('\n'))
    except FileNotFoundError:
        return 0
    except Exception as e:
        print(f"An error occurred while reading from the file: {e}")
        return 0

async def read_from_file():
    try:
        async with aiofiles.open(FILENAME, 'r') as file:
            accounts = await file.read()
            return accounts.strip()
    except FileNotFoundError:
        return None
    except Exception as e:
        print(f"An error occurred while reading from the file: {e}")
        return None

async def get_available_accounts():
    try:
        async with aiofiles.open(FILENAME, mode='r') as file:
            existing_lines = await file.read()
            used_keys = set(line.split(':')[0] for line in existing_lines.split('\n'))
            all_keys = [f'{prefix}:{suffix}' for prefix in 'abcdefghijklmnopqrstuvwxyz' for suffix in 'abcdefghijklmnopqrstuvwxyz']
            available = [key for key in all_keys if key not in used_keys]
            print(f"Used keys: {used_keys}")
            print(f"Available keys: {available}")
            return available
    except FileNotFoundError:
        return None
    except Exception as e:
        print(f"An error occurred while reading from the file: {e}")
        return None

async def write_to_file(accounts):
    try:
        async with aiofiles.open(FILENAME, 'w') as file:
            await file.write(accounts)
    except Exception as e:
        print(f"An error occurred while writing to the file: {e}")
        
@bot.command()
@commands.check(has_owner_role)
async def add(ctx, *, accounts: str):
    accounts_list = [acc.strip() for acc in accounts.split('\n')]

    existing_accounts = await read_from_file()

    all_accounts = set(existing_accounts.splitlines()) | set(accounts_list)

    await write_to_file('\n'.join(all_accounts))

    await ctx.send(f"Added {len(accounts_list)} accounts to the file!")

@bot.command()
@commands.check(has_owner_role)
async def auth(ctx, roblox_id: str):
    try:
        # Convert roblox_id to an integer
        roblox_id = int(roblox_id)

        g = Github(GITHUB_TOKEN)
        repo = g.get_repo(f"{REPO_OWNER}/{REPO_NAME}")
        file = repo.get_contents(FILE_PATH)
        script_content = base64.b64decode(file.content).decode('utf-8')

        # Check if the Roblox ID is already authorized
        if str(roblox_id) in script_content:
            await send_colored_embed(ctx, f"User with Roblox ID {roblox_id} is already authorized.", discord.Color.red())
            return

        # Add the new Roblox ID
        new_content = script_content.replace(
            "local authorizedUsers = {", 
            f"local authorizedUsers = {{\n    {roblox_id},"
        )
        await update_lua_script(repo, FILE_PATH, new_content)
        await send_colored_embed(ctx, f"User with Roblox ID {roblox_id} has been authorized.", discord.Color.green())

    except ValueError:
        await send_colored_embed(ctx, f"'{roblox_id}' is not a valid user ID.", discord.Color.red())
    except Exception as e:
        await send_colored_embed(ctx, f"An error occurred: {str(e)}", discord.Color.red())
        

@bot.command()
@commands.check(has_owner_role)
async def authed(ctx):
    g = Github(GITHUB_TOKEN)
    repo = g.get_repo(f"{REPO_OWNER}/{REPO_NAME}")
    file = repo.get_contents(FILE_PATH)
    script_content = base64.b64decode(file.content).decode('utf-8')
    start_index = script_content.find("local authorizedUsers = {") + len("local authorizedUsers = {") + 1
    end_index = script_content.find("}", start_index)
    authorized_users_str = script_content[start_index:end_index].strip()
    authorized_users = [user.strip('"') for user in authorized_users_str.split(",")]

    embed = discord.Embed(title="Authorized Users", description="\n".join(authorized_users), color=discord.Color.green())
    embed.set_footer(text="This list cannot be modified.")
    await ctx.send(embed=embed)

@bot.command()
@commands.check(has_owner_role)
async def reauth(ctx):
    try:
        g = Github(GITHUB_TOKEN)
        repo = g.get_repo(f"{REPO_OWNER}/{REPO_NAME}")
        file = repo.get_contents(FILE_PATH)
        script_content = base64.b64decode(file.content).decode('utf-8')

        # Reset the authorized users list
        cleared_content = re.sub(r"local authorizedUsers = {.*?}", "local authorizedUsers = {}", script_content, flags=re.DOTALL)
        await update_lua_script(repo, FILE_PATH, cleared_content)

        # Notify the user
        await send_colored_embed(ctx, "All authorized user IDs have been cleared.", discord.Color.purple())

    except Exception as e:
        await send_colored_embed(ctx, f"An error occurred: {str(e)}", discord.Color.red())
    
@bot.command()
@commands.check(has_owner_role)
async def unauth(ctx, roblox_user):
    g = Github(GITHUB_TOKEN)
    repo = g.get_repo(f"{REPO_OWNER}/{REPO_NAME}")
    file = repo.get_contents(FILE_PATH)
    script_content = base64.b64decode(file.content).decode('utf-8')
    lines = script_content.split('\n')
    new_lines = [line for line in lines if roblox_user not in line]
    new_content = '\n'.join(new_lines)
    if new_content != script_content:  # Check if the content has changed
        await update_lua_script(repo, FILE_PATH, new_content)
        await send_colored_embed(ctx, f"User {roblox_user} has been unauthorized.", discord.Color.red())
    else:
        await send_colored_embed(ctx, f"User {roblox_user} is not authorized.", discord.Color.purple())

async def update_lua_script(repo, file_path, new_content):
    file = repo.get_contents(file_path)
    repo.update_file(file.path, "Update authorization script", new_content, file.sha)

async def send_colored_embed(ctx, content, color):
    embed = create_embed_response(content, color)
    await ctx.send(embed=embed)
        
class AuthCog(commands.Cog):
    def __init__(self, bot):
        self.bot = bot
        self.last_auth = {}  
        self.cooldowns = {}

    @commands.command()
    @commands.check(is_paid_user)
    async def pauth(self, ctx, roblox_id: str):
        try:
            # Convert roblox_id to an integer
            roblox_id = int(roblox_id)
            author_id = ctx.author.id
            current_time = asyncio.get_event_loop().time()

            if author_id not in self.cooldowns or current_time - self.cooldowns[author_id] >= COOLDOWN_TIME:
                g = Github(GITHUB_TOKEN)
                repo = g.get_repo(f"{REPO_OWNER}/{REPO_NAME}")
                file = repo.get_contents(FILE_PATH)
                script_content = base64.b64decode(file.content).decode('utf-8')

                # Remove the previously authorized ID for this user
                if author_id in self.last_auth:
                    last_auth_id = self.last_auth[author_id]
                    script_content = script_content.replace(f"\n    {last_auth_id},", "")
                    script_content = script_content.replace(f"{last_auth_id},", "")
                    await self.update_lua_script(repo, FILE_PATH, script_content)

                # Check if the new ID is already authorized
                if str(roblox_id) not in script_content:
                    new_content = script_content.replace(
                        "local authorizedUsers = {",
                        f"local authorizedUsers = {{\n    {roblox_id},"
                    )
                    await self.update_lua_script(repo, FILE_PATH, new_content)
                    await self.send_colored_embed(ctx, f"User with Roblox ID {roblox_id} has been authorized.", discord.Color.green())
                    self.last_auth[author_id] = roblox_id
                    self.cooldowns[author_id] = current_time
                else:
                    await self.send_colored_embed(ctx, f"User with Roblox ID {roblox_id} is already authorized.", discord.Color.red())
            else:
                remaining_time = COOLDOWN_TIME - (current_time - self.cooldowns[author_id])
                await ctx.send(f"Command on cooldown. Please wait {remaining_time:.2f} seconds before using it again.")

        except ValueError:
            await self.send_colored_embed(ctx, f"'{roblox_id}' is not a valid user ID.", discord.Color.red())
        except Exception as e:
            await self.send_colored_embed(ctx, f"An error occurred: {str(e)}", discord.Color.red())

    @commands.command()
    @commands.check(has_owner_role)
    async def rst(self, ctx: commands.Context, user: discord.Member):
        self.bot.get_command('pauth').reset_cooldown(user)
        self.cooldowns[user.id] = 0  # Reset cooldown for the mentioned member
        await self.send_colored_embed(ctx, f"The cooldown for {user.mention} has been reset.", discord.Color.green())

    async def update_lua_script(self, repo, file_path, new_content):
        file = repo.get_contents(file_path)
        repo.update_file(file.path, "Update authorization script", new_content, file.sha)

    async def send_colored_embed(self, ctx, content, color):
        embed = create_embed_response(content, color)
        await ctx.send(embed=embed)
 
@bot.event
async def on_command_error(ctx, error):
    if isinstance(error, commands.CommandNotFound):
        return
    print(f"An error occurred: {error}")

async def main():
    await bot.add_cog(AuthCog(bot))

if __name__ == "__main__":
    asyncio.run(main())
    bot.run(DISCORD_TOKEN)
